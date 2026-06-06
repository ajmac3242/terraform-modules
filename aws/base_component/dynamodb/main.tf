# DynamoDB Table resource
resource "aws_dynamodb_table" "this" {
  name         = var.table_name
  billing_mode = var.billing_mode
  hash_key     = var.hash_key
  range_key    = var.range_key

  # Dynamic attribute definitions
  dynamic "attribute" {
    for_each = var.attributes
    content {
      name = attribute.value.name
      type = attribute.value.type
    }
  }

  # Server-side encryption with mandatory CMK
  server_side_encryption {
    enabled     = true
    kms_key_arn = var.kms_key_arn
  }

  # Point-in-time recovery for data protection
  point_in_time_recovery {
    enabled = var.pitr_enabled
  }

  tags = var.tags
}

# Local variable to support tests/mocking
locals {
  _unused_mock_account_id = var.aws_account_id
}
