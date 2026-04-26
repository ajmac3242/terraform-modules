variables {
  name              = "test-sfn-lambda"
  kms_key_arn       = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"
  lambda_arns       = ["arn:aws:lambda:us-east-1:123456789012:function:test-function"]
  definition        = "{\"StartAt\":\"Pass\",\"States\":{\"Pass\":{\"Type\":\"Pass\",\"End\":true}}}"
  skip_sfn_creation = true
  aws_account_id    = "123456789012"
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
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
  access_key                  = "mock_access_key"
  secret_key                  = "mock_secret_key"
}

run "iam_validation" {
  command = plan

  assert {
    condition     = module.role.role_name == "${var.name}-role"
    error_message = "IAM role name should match expected value"
  }

  assert {
    condition     = aws_iam_policy.this.name == "${var.name}-policy"
    error_message = "IAM policy name should match expected value"
  }
}
