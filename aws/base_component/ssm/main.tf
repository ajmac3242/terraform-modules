# SSM Parameter resource (SecureString by default)
resource "aws_ssm_parameter" "this" {
  name        = var.name
  description = var.description
  type        = "SecureString"
  value       = var.value
  key_id      = var.kms_key_arn

  tags = var.tags
}

# Local variable to support tests/mocking
locals {
  _unused_mock_account_id = var.aws_account_id
}
