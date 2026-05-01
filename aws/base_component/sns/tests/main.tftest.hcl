variables {
  name        = "test-topic"
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

run "valid_sns_creation" {
  command = plan

  assert {
    condition     = aws_sns_topic.this.name == var.name
    error_message = "SNS topic name does not match expected value"
  }

  assert {
    condition     = aws_sns_topic.this.kms_master_key_id == var.kms_key_arn
    error_message = "KMS key ID does not match expected value"
  }

  assert {
    condition     = aws_sns_topic.this.tags["environment"] == "test" && aws_sns_topic.this.tags["owner"] == "test-owner" && aws_sns_topic.this.tags["project"] == "test-project" && aws_sns_topic.this.tags["cost_center"] == "test-cc"
    error_message = "Mandatory tags are missing or incorrect on SNS topic"
  }
}
