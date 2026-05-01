variables {
  name        = "test-parameter"
  description = "A test parameter"
  value       = "test-value"
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

run "valid_parameter_creation" {
  command = plan

  assert {
    condition     = aws_ssm_parameter.this.name == var.name
    error_message = "SSM parameter name does not match expected value"
  }

  assert {
    condition     = aws_ssm_parameter.this.type == "SecureString"
    error_message = "SSM parameter should be SecureString"
  }

  assert {
    condition     = aws_ssm_parameter.this.key_id == var.kms_key_arn
    error_message = "KMS key ID does not match expected value"
  }

  assert {
    condition     = aws_ssm_parameter.this.tags["environment"] == "test" && aws_ssm_parameter.this.tags["owner"] == "test-owner" && aws_ssm_parameter.this.tags["project"] == "test-project" && aws_ssm_parameter.this.tags["cost_center"] == "test-cc"
    error_message = "Mandatory tags are missing or incorrect on SSM parameter"
  }
}
