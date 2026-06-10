# Data source to get current account ID if not provided
data "aws_caller_identity" "current" {}

locals {
  account_id = data.aws_caller_identity.current.account_id
}

# CloudWatch Log Group for Step Functions with mandatory KMS encryption
resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/vendedlogs/states/${var.name}"
  retention_in_days = var.log_group_retention_in_days
  kms_key_id        = var.kms_key_arn

  tags = var.tags
}

# Main Step Functions State Machine resource
resource "aws_sfn_state_machine" "this" {
  count    = var.skip_sfn_creation ? 0 : 1
  name     = var.name
  role_arn = var.role_arn
  type     = var.type

  definition = var.definition

  # Enforce logging and encryption
  logging_configuration {
    log_destination        = "${aws_cloudwatch_log_group.this.arn}:*"
    include_execution_data = true
    level                  = "ALL"
  }

  tracing_configuration {
    enabled = true
  }

  tags = var.tags
}
