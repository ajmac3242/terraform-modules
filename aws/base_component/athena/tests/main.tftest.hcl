variables {
  name            = "test-workgroup"
  output_location = "s3://test-bucket/results/"
  kms_key_arn     = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"
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

run "valid_athena_creation" {
  command = plan

  assert {
    condition     = aws_athena_workgroup.this.name == var.name
    error_message = "Athena workgroup name does not match expected value"
  }

  assert {
    condition     = aws_athena_workgroup.this.configuration[0].enforce_workgroup_configuration == true
    error_message = "Enforced configuration must be true"
  }

  assert {
    condition     = aws_athena_workgroup.this.configuration[0].result_configuration[0].encryption_configuration[0].kms_key_arn == var.kms_key_arn
    error_message = "KMS key ARN does not match expected value"
  }

  assert {
    condition     = aws_athena_workgroup.this.tags["environment"] == "test" && aws_athena_workgroup.this.tags["owner"] == "test-owner" && aws_athena_workgroup.this.tags["project"] == "test-project" && aws_athena_workgroup.this.tags["cost_center"] == "test-cc"
    error_message = "Mandatory tags are missing or incorrect on Athena workgroup"
  }
}
