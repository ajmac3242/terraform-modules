variables {
  agent_name              = "test-agent"
  foundation_model        = "anthropic.claude-v2"
  instruction             = "You are a test agent. Your purpose is to provide a long enough instruction to satisfy the minimum length requirement of the AWS Bedrock Agent resource."
  agent_resource_role_arn = "arn:aws:iam::123456789012:role/test-role"
  kms_key_arn             = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"
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

run "valid_agent_creation" {
  command = plan

  assert {
    condition     = aws_bedrockagent_agent.this.agent_name == var.agent_name
    error_message = "Agent name does not match"
  }

  assert {
    condition     = aws_bedrockagent_agent.this.foundation_model == var.foundation_model
    error_message = "Foundation model does not match"
  }

  assert {
    condition     = aws_bedrockagent_agent.this.customer_encryption_key_arn == var.kms_key_arn
    error_message = "KMS encryption key not set correctly"
  }

  assert {
    condition     = aws_bedrockagent_agent.this.tags["environment"] == "test" && aws_bedrockagent_agent.this.tags["owner"] == "test-owner" && aws_bedrockagent_agent.this.tags["project"] == "test-project" && aws_bedrockagent_agent.this.tags["cost_center"] == "test-cc"
    error_message = "Mandatory tags are missing or incorrect on Bedrock Agent"
  }
}

run "valid_agent_creation_with_guardrail" {
  command = plan

  variables {
    guardrail_configuration = {
      guardrail_identifier = "test-guardrail-id"
      guardrail_version    = "1"
    }
  }

  assert {
    condition     = length(aws_bedrockagent_agent.this.guardrail_configuration) > 0
    error_message = "Guardrail configuration is missing"
  }

  assert {
    condition     = aws_bedrockagent_agent.this.guardrail_configuration[0].guardrail_identifier == "test-guardrail-id"
    error_message = "Guardrail identifier does not match"
  }
}
