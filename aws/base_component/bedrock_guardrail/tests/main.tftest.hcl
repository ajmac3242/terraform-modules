# Mock provider for offline testing
provider "aws" {
  region                      = "us-east-1"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true
  access_key                  = "mock_access_key"
  secret_key                  = "mock_secret_key"
}

run "validate_guardrail" {
  command = plan

  variables {
    name                      = "test-guardrail"
    blocked_input_messaging   = "blocked input"
    blocked_outputs_messaging = "blocked output"
    kms_key_arn               = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"

    content_policy_config = {
      filters_config = [
        {
          type            = "HATE"
          input_strength  = "HIGH"
          output_strength = "HIGH"
        }
      ]
    }

    tags = {
      environment = "test"
      owner       = "test-owner"
      project     = "test-project"
      cost_center = "test-cost-center"
    }
  }

  assert {
    condition     = aws_bedrock_guardrail.this.name == "test-guardrail"
    error_message = "Guardrail name did not match expected value"
  }

  assert {
    condition     = aws_bedrock_guardrail.this.kms_key_arn == "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"
    error_message = "KMS key ARN did not match expected value"
  }

  assert {
    condition     = alltrue([for k in ["environment", "owner", "project", "cost_center"] : contains(keys(aws_bedrock_guardrail.this.tags), k)])
    error_message = "Mandatory tags are missing"
  }
}
