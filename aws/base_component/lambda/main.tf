# Automatically manage KMS key if not provided
module "kms" {
  count  = var.kms_key_arn == null ? 1 : 0
  source = "../kms"

  name                 = "${var.function_name}-key"
  description          = "KMS key for Lambda function ${var.function_name}"
  admin_principal_arns = []
  usage_principal_arns = []
  aws_account_id       = var.aws_account_id

  tags = var.tags
}

locals {
  kms_key_arn = var.kms_key_arn != null ? var.kms_key_arn : module.kms[0].key_arn
  # Filter S3 Files ARNs from file_system_config for IAM policy creation
  s3_mount_arns = [for f in var.file_system_config : f.arn if can(regex("^arn:aws:s3files:", f.arn))]
}

# IAM policy for S3 Files system mounting
resource "aws_iam_policy" "s3_mount" {
  count       = length(local.s3_mount_arns) > 0 && var.existing_role_arn == null ? 1 : 0
  name        = "${var.function_name}-s3-mount-policy"
  description = "IAM policy for S3 Files system mounting for ${var.function_name}"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3files:ClientMount",
          "s3files:ClientWrite"
        ]
        Effect   = "Allow"
        Resource = local.s3_mount_arns
      }
    ]
  })

  tags = var.tags
}

# Lambda execution role using the base IAM module
module "execution_role" {
  count  = var.existing_role_arn == null ? 1 : 0
  source = "../iam"

  role_name   = "${var.function_name}-role"
  description = "Execution role for ${var.function_name}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
  # Basic execution and VPC access policies are attached by default
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole",
    "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
  ]

  permissions_boundary_arn = var.permissions_boundary_arn

  tags = var.tags
}

# Attach S3 mount policy to the execution role
resource "aws_iam_role_policy_attachment" "s3_mount" {
  count      = length(local.s3_mount_arns) > 0 && var.existing_role_arn == null ? 1 : 0
  role       = module.execution_role[0].role_name
  policy_arn = aws_iam_policy.s3_mount[0].arn
}

# Main Lambda function resource
resource "aws_lambda_function" "this" {
  function_name = var.function_name
  description   = var.description
  role          = var.existing_role_arn != null ? var.existing_role_arn : module.execution_role[0].role_arn

  runtime = var.runtime
  handler = var.handler
  layers  = var.layers

  filename = var.filename
  # source_code_hash handles change detection and is resilient to missing files in CI/plan
  source_code_hash = var.filename != null ? (fileexists(var.filename) ? filebase64sha256(var.filename) : null) : null

  memory_size = var.memory_size
  timeout     = var.timeout

  kms_key_arn = local.kms_key_arn

  reserved_concurrent_executions = var.reserved_concurrent_executions

  # Optional VPC placement
  dynamic "vpc_config" {
    for_each = var.vpc_config != null ? [var.vpc_config] : []
    content {
      subnet_ids         = vpc_config.value.subnet_ids
      security_group_ids = vpc_config.value.security_group_ids
    }
  }

  # Active tracing with X-Ray is enabled by default
  tracing_config {
    mode = "Active"
  }

  dynamic "file_system_config" {
    for_each = var.file_system_config
    content {
      arn              = file_system_config.value.arn
      local_mount_path = file_system_config.value.local_mount_path
    }
  }

  dynamic "dead_letter_config" {
    for_each = var.dead_letter_config_target_arn != null ? [1] : []
    content {
      target_arn = var.dead_letter_config_target_arn
    }
  }

  environment {
    variables = var.environment_variables
  }

  tags = var.tags
}

# CloudWatch log group with mandatory KMS encryption
resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/lambda/${var.function_name}"
  retention_in_days = var.retention_in_days
  kms_key_id        = local.kms_key_arn

  tags = var.tags
}
