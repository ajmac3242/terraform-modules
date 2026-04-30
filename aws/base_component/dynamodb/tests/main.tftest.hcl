variables {
  table_name = "test-table"
  hash_key   = "id"
  attributes = [
    {
      name = "id"
      type = "S"
    }
  ]
  kms_key_arn = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"
  tags = {
    environment = "test"
    owner       = "test-owner"
    project     = "test-project"
    cost_center = "test-cc"
  }
}

provider "aws" {
  region                      = "us-east-1"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true
  access_key                  = "mock_access_key"
  secret_key                  = "mock_secret_key"
}

run "valid_table_creation" {
  command = plan

  assert {
    condition     = aws_dynamodb_table.this.name == var.table_name
    error_message = "DynamoDB table name does not match expected value"
  }

  assert {
    condition     = aws_dynamodb_table.this.point_in_time_recovery[0].enabled == true
    error_message = "PITR should be enabled by default"
  }

  assert {
    condition     = aws_dynamodb_table.this.server_side_encryption[0].kms_key_arn == var.kms_key_arn
    error_message = "KMS key ARN does not match expected value"
  }

  assert {
    condition     = aws_dynamodb_table.this.tags["environment"] == "test" && aws_dynamodb_table.this.tags["owner"] == "test-owner" && aws_dynamodb_table.this.tags["project"] == "test-project" && aws_dynamodb_table.this.tags["cost_center"] == "test-cc"
    error_message = "Mandatory tags are missing or incorrect on DynamoDB table."
  }
}
