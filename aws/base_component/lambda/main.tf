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

# Main Lambda function resource
resource "aws_lambda_function" "this" {
  function_name = var.function_name
  description   = var.description
  role          = var.existing_role_arn != null ? var.existing_role_arn : module.execution_role[0].role_arn

  runtime = var.runtime
  handler = var.handler

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
