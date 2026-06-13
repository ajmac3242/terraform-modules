# Main SNS Topic resource
resource "aws_sns_topic" "this" {
  name              = var.name
  kms_master_key_id = var.kms_key_arn

  tags = var.tags
}

# Local variable to support tests/mocking
locals {
  _unused_mock_account_id = var.aws_account_id
}
