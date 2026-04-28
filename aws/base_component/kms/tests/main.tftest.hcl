variables {
  name           = "test-key"
  description    = "Test KMS Key"
  aws_account_id = "123456789012"
  admin_principal_arns = [
    "arn:aws:iam::123456789012:root"
  ]
  usage_principal_arns = [
    "arn:aws:iam::123456789012:root"
  ]
  tags = {
    environment = "test"
    owner       = "forge"
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

run "verify_kms_key" {
  command = plan

  assert {
    condition     = aws_kms_key.this.enable_key_rotation == true
    error_message = "KMS key rotation must be enabled."
  }

  assert {
    condition     = aws_kms_alias.this.name == "alias/test-key"
    error_message = "KMS alias name is incorrect."
  }

  assert {
    condition     = aws_kms_key.this.multi_region == false
    error_message = "KMS multi_region should be false by default."
  }

  assert {
    condition     = aws_kms_key.this.deletion_window_in_days == 30
    error_message = "KMS deletion window should be 30 days by default."
  }

  assert {
    condition     = aws_kms_key.this.tags["environment"] == "test" && aws_kms_key.this.tags["owner"] == "forge" && aws_kms_key.this.tags["project"] == "test-project" && aws_kms_key.this.tags["cost_center"] == "test-cc"
    error_message = "Mandatory tags are missing or incorrect on KMS key."
  }
}

run "verify_kms_key_validation" {
  command = plan

  variables {
    deletion_window_in_days = 14
  }

  assert {
    condition     = aws_kms_key.this.deletion_window_in_days == 14
    error_message = "KMS deletion window should be 14 days when specified."
  }
}

run "verify_kms_key_invalid_deletion_window" {
  command = plan

  variables {
    deletion_window_in_days = 7
  }

  expect_failures = [
    var.deletion_window_in_days
  ]
}
