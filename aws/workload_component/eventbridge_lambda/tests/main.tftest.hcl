variables {
  name                 = "test-rule"
  description          = "Test rule description"
  event_pattern        = "{\"source\":[\"test\"]}"
  lambda_function_name = "test-function"
  lambda_handler       = "index.handler"
  lambda_runtime       = "nodejs18.x"
  lambda_source_path   = "test.zip" # Mocking file check
  aws_account_id       = "123456789012"
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

run "valid_eventbridge_lambda_creation" {
  command = plan

  assert {
    condition     = module.lambda.function_name == var.lambda_function_name
    error_message = "Lambda function name does not match"
  }

  assert {
    condition     = length(module.eventbridge.rule_arns) == 1
    error_message = "EventBridge rule should be created"
  }

  assert {
    condition     = aws_lambda_permission.allow_eventbridge.principal == "events.amazonaws.com"
    error_message = "Lambda permission principal should be events.amazonaws.com"
  }
}

run "with_dlq_enabled" {
  command = plan

  variables {
    enable_dlq = true
  }

  assert {
    condition     = length(module.dlq) == 1
    error_message = "DLQ should be created when enabled"
  }
}
