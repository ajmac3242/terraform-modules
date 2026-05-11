variables {
  name        = "test-gateway"
  role_arn    = "arn:aws:iam::123456789012:role/test-role"
  kms_key_arn = "arn:aws:kms:us-east-1:123456789012:key/test-key-id"
  description = "A test gateway"
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

run "valid_gateway_creation" {
  command = plan

  assert {
    condition     = aws_bedrockagentcore_gateway.this.name == var.name
    error_message = "Gateway name does not match expected value"
  }

  assert {
    condition     = aws_bedrockagentcore_gateway.this.role_arn == var.role_arn
    error_message = "Gateway role ARN does not match expected value"
  }

  assert {
    condition     = aws_bedrockagentcore_gateway.this.kms_key_arn == var.kms_key_arn
    error_message = "Gateway KMS key ARN does not match expected value"
  }

  assert {
    condition     = aws_bedrockagentcore_gateway.this.description == var.description
    error_message = "Gateway description does not match expected value"
  }

  assert {
    condition     = aws_bedrockagentcore_gateway.this.tags["environment"] == "test" && aws_bedrockagentcore_gateway.this.tags["owner"] == "test-owner" && aws_bedrockagentcore_gateway.this.tags["project"] == "test-project" && aws_bedrockagentcore_gateway.this.tags["cost_center"] == "test-cc"
    error_message = "Mandatory tags are missing or incorrect on Bedrock AgentCore Gateway"
  }
}
