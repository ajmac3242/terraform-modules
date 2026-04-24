variables {
  name        = "test-sfn"
  role_arn    = "arn:aws:iam::123456789012:role/test-role"
  kms_key_arn = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"
  definition  = "{\"StartAt\":\"Pass\",\"States\":{\"Pass\":{\"Type\":\"Pass\",\"End\":true}}}"
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

run "valid_sfn_creation" {
  command = plan

  assert {
    condition     = aws_sfn_state_machine.this.name == var.name
    error_message = "SFN name does not match expected value"
  }

  assert {
    condition     = aws_cloudwatch_log_group.this.kms_key_id == var.kms_key_arn
    error_message = "Log group should be encrypted with CMK"
  }
}
