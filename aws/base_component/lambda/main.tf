# Lambda execution role using the base IAM module
module "execution_role" {
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

  tags = var.tags
}

# Main Lambda function resource
resource "aws_lambda_function" "this" {
  function_name = var.function_name
  description   = var.description
  role          = module.execution_role.role_arn

  runtime = var.runtime
  handler = var.handler

  filename = var.filename
  # source_code_hash handles change detection and is resilient to missing files in CI/plan
  source_code_hash = var.filename != null ? (fileexists(var.filename) ? filebase64sha256(var.filename) : null) : null

  memory_size = var.memory_size
  timeout     = var.timeout

  kms_key_arn = var.kms_key_arn

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

  environment {
    variables = var.environment_variables
  }

  tags = var.tags
}

# CloudWatch log group with mandatory KMS encryption
resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/lambda/${var.function_name}"
  retention_in_days = var.retention_in_days
  kms_key_id        = var.kms_key_arn

  tags = var.tags
}
