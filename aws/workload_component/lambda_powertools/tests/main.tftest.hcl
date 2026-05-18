variables {
  function_name        = "test-powertools"
  filename             = "dummy.zip"
  service_name         = "test-service"
  powertools_layer_arn = "arn:aws:lambda:us-east-1:017000801446:layer:AWSLambdaPowertoolsPythonV2:60"
  aws_account_id       = "123456789012"
  tags = {
    environment = "test"
    owner       = "builder"
    project     = "infrastructure"
    cost_center = "12345"
  }
}

provider "aws" {
  region                      = "us-east-1"
  access_key                  = "mock_access_key"
  secret_key                  = "mock_secret_key"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
}

run "validate_lambda_powertools_creation" {
  command = plan

  assert {
    condition     = module.lambda.function_name == var.function_name
    error_message = "Function name does not match input"
  }

  assert {
    condition     = contains(module.lambda.layers, var.powertools_layer_arn)
    error_message = "Powertools layer is missing"
  }

  assert {
    condition     = module.lambda.environment_variables["POWERTOOLS_SERVICE_NAME"] == var.service_name
    error_message = "POWERTOOLS_SERVICE_NAME environment variable is incorrect"
  }

  assert {
    condition     = module.lambda.environment_variables["LOG_LEVEL"] == "INFO"
    error_message = "LOG_LEVEL environment variable should be INFO by default"
  }

  assert {
    condition     = module.lambda.tags["environment"] == "test" && module.lambda.tags["owner"] == "builder" && module.lambda.tags["project"] == "infrastructure" && module.lambda.tags["cost_center"] == "12345"
    error_message = "Mandatory tags are missing or incorrect"
  }
}
