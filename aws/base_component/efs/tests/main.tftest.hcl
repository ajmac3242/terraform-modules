variables {
  name       = "test-efs"
  kms_key_id = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"
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
}
