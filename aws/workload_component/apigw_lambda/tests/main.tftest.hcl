variables {
  name            = "test-apigw"
  description     = "A test API GW + Lambda"
  runtime         = "nodejs18.x"
  handler         = "index.handler"
  filename        = "dummy.zip"
  kms_key_arn     = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"
  jwt_issuer      = "https://example.com"
  jwt_audience    = ["test-audience"]
  waf_web_acl_arn = "arn:aws:wafv2:us-east-1:123456789012:regional/webacl/test-waf/12345678-1234-1234-1234-123456789012"
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

run "valid_apigw_lambda_creation" {
  command = plan

  assert {
    condition     = aws_apigatewayv2_api.this.name == var.name
    error_message = "API Gateway name does not match expected value"
  }

  assert {
    condition     = aws_apigatewayv2_stage.this.name == "$default"
    error_message = "Stage name should be $default"
  }

  assert {
    condition     = aws_apigatewayv2_authorizer.this[0].authorizer_type == "JWT"
    error_message = "Authorizer type should be JWT"
  }

  assert {
    condition     = aws_apigatewayv2_route.this.authorization_type == "JWT"
    error_message = "Route authorization type should be JWT"
  }

  assert {
    condition     = aws_wafv2_web_acl_association.this.web_acl_arn == var.waf_web_acl_arn
    error_message = "WAF Web ACL association ARN does not match"
  }
}
