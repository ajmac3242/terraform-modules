variables {
  name        = "test-api"
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

run "valid_api_creation" {
  command = plan

  assert {
    condition     = aws_apigatewayv2_api.this.name == var.name
    error_message = "API name does not match expected value"
  }

  assert {
    condition     = aws_apigatewayv2_api.this.protocol_type == "HTTP"
    error_message = "API protocol type is not HTTP"
  }

  assert {
    condition     = aws_cloudwatch_log_group.this.kms_key_id == var.kms_key_arn
    error_message = "CloudWatch log group KMS key ID does not match"
  }

  assert {
    condition     = aws_apigatewayv2_api.this.tags["environment"] == "test" && aws_apigatewayv2_api.this.tags["owner"] == "test-owner" && aws_apigatewayv2_api.this.tags["project"] == "test-project" && aws_apigatewayv2_api.this.tags["cost_center"] == "test-cc"
    error_message = "Mandatory tags are missing or incorrect on API"
  }

  assert {
    condition     = aws_apigatewayv2_stage.this.auto_deploy == true
    error_message = "API stage auto-deploy is not enabled"
  }
}
