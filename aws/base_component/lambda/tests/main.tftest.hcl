variables {
  function_name  = "test-lambda"
  description    = "A test lambda function"
  runtime        = "nodejs18.x"
  handler        = "index.handler"
  filename       = "dummy.zip"
  aws_account_id = "123456789012" # Avoid data source failure in mock environment
  kms_key_arn    = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"
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

run "valid_lambda_creation" {
  command = plan

  assert {
    condition     = aws_lambda_function.this.function_name == var.function_name
    error_message = "Lambda function name does not match expected value"
  }

  assert {
    condition     = aws_lambda_function.this.tracing_config[0].mode == "Active"
    error_message = "X-Ray tracing should be Active by default"
  }

  assert {
    condition     = aws_cloudwatch_log_group.this.name == "/aws/lambda/${var.function_name}"
    error_message = "Log group name is incorrect"
  }
}
