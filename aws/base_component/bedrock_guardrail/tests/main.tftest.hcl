variables {
  name                      = "test-guardrail"
  blocked_input_messaging   = "Input blocked"
  blocked_outputs_messaging = "Output blocked"
  kms_key_arn               = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"
  tags = {
    environment = "test"
    owner       = "builder"
    project     = "infrastructure"
    cost_center = "12345"
  }
  content_policy_config = [{
    filters_config = [
      {
        type            = "HATE"
        input_strength  = "HIGH"
        output_strength = "HIGH"
      }
    ]
  }]
}

provider "aws" {
  region                      = "us-east-1"
  access_key                  = "mock_access_key"
  secret_key                  = "mock_secret_key"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
}

run "validate_guardrail_creation" {
  command = plan

  assert {
    condition     = aws_bedrock_guardrail.this.name == var.name
    error_message = "Guardrail name does not match input"
  }

  assert {
    condition     = aws_bedrock_guardrail.this.kms_key_arn == var.kms_key_arn
    error_message = "KMS key ARN does not match input"
  }

  assert {
    condition     = aws_bedrock_guardrail.this.tags["environment"] == "test"
    error_message = "Mandatory environment tag is missing or incorrect"
  }

  assert {
    condition     = length(aws_bedrock_guardrail.this.content_policy_config) > 0
    error_message = "Content policy config is missing"
  }
}
