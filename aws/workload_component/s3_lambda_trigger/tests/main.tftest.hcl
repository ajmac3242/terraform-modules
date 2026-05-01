variables {
  bucket_name          = "test-trigger-bucket"
  lambda_function_name = "test-trigger-function"
  lambda_description   = "Test trigger description"
  lambda_handler       = "index.handler"
  lambda_runtime       = "nodejs18.x"
  lambda_source_path   = "test.zip"
  log_bucket_id        = "mock-log-bucket"
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

run "valid_s3_lambda_trigger_creation" {
  command = plan

  assert {
    condition     = module.lambda.function_name == var.lambda_function_name
    error_message = "Lambda function name does not match"
  }

  assert {
    condition     = aws_lambda_permission.allow_s3.principal == "s3.amazonaws.com"
    error_message = "Lambda permission principal should be s3.amazonaws.com"
  }

  assert {
    condition     = length(aws_s3_bucket_notification.this.lambda_function) == 1
    error_message = "S3 bucket notification should have one lambda function target"
  }

  assert {
    condition     = module.s3.tags["environment"] == "test" && module.s3.tags["owner"] == "test-owner" && module.s3.tags["project"] == "test-project" && module.s3.tags["cost_center"] == "test-cc"
    error_message = "Mandatory tags are missing or incorrect on S3 bucket"
  }

  assert {
    condition     = module.lambda.tags["environment"] == "test" && module.lambda.tags["owner"] == "test-owner" && module.lambda.tags["project"] == "test-project" && module.lambda.tags["cost_center"] == "test-cc"
    error_message = "Mandatory tags are missing or incorrect on Lambda function"
  }
}
