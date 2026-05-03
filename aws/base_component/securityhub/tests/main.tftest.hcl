provider "aws" {
  region                      = "us-east-1"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true
  access_key                  = "mock_access_key"
  secret_key                  = "mock_secret_key"
}

variables {
  enable_finding_aggregator = true

  tags = {
    environment = "test"
    owner       = "security-team"
    project     = "standardization"
    cost_center = "12345"
  }
}

run "validate_securityhub_creation" {
  command = plan

  # Security Hub resources (account, standards_subscription, finding_aggregator)
  # do not support AWS tags.

  override_data {
    target = data.aws_caller_identity.current
    values = {
      account_id = "123456789012"
      arn        = "arn:aws:iam::123456789012:user/test"
      user_id    = "test"
    }
  }

  assert {
    condition     = aws_securityhub_account.this.enable_default_standards == true
    error_message = "Default standards should be enabled"
  }

  assert {
    condition     = aws_securityhub_account.this.control_finding_generator == "SECURITY_CONTROL"
    error_message = "Control finding generator should be SECURITY_CONTROL"
  }

  assert {
    condition     = length(aws_securityhub_finding_aggregator.this) == 1
    error_message = "Finding aggregator should be created"
  }
}
