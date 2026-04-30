variables {
  name        = "test-efs"
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

run "valid_efs_creation" {
  command = plan

  assert {
    condition     = aws_efs_file_system.this.creation_token == var.name
    error_message = "EFS name does not match expected value"
  }

  assert {
    condition     = aws_efs_file_system.this.encrypted == true
    error_message = "EFS should be encrypted"
  }

  assert {
    condition     = aws_efs_file_system.this.kms_key_id == var.kms_key_arn
    error_message = "EFS KMS key ARN does not match expected value"
  }

  assert {
    condition     = aws_efs_file_system.this.tags["environment"] == "test" && aws_efs_file_system.this.tags["owner"] == "test-owner" && aws_efs_file_system.this.tags["project"] == "test-project" && aws_efs_file_system.this.tags["cost_center"] == "test-cc"
    error_message = "Mandatory tags are missing or incorrect on EFS file system."
  }
}
