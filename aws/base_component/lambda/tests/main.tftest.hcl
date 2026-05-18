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

  assert {
    condition     = aws_lambda_function.this.kms_key_arn == var.kms_key_arn
    error_message = "KMS key ARN does not match expected value"
  }

  assert {
    condition     = aws_lambda_function.this.tags["environment"] == "test" && aws_lambda_function.this.tags["owner"] == "test-owner" && aws_lambda_function.this.tags["project"] == "test-project" && aws_lambda_function.this.tags["cost_center"] == "test-cc"
    error_message = "Mandatory tags are missing or incorrect on Lambda function"
  }
}

run "lambda_with_s3_mount" {
  command = plan

  variables {
    file_system_config = [
      {
        arn              = "arn:aws:s3files:us-east-1:123456789012:accesspoint/my-ap"
        local_mount_path = "/mnt/s3"
      }
    ]
  }

  assert {
    condition     = length(aws_lambda_function.this.file_system_config) == 1
    error_message = "Lambda function should have 1 file system configuration"
  }

  assert {
    condition     = aws_lambda_function.this.file_system_config[0].arn == "arn:aws:s3files:us-east-1:123456789012:accesspoint/my-ap"
    error_message = "File system ARN does not match expected S3 Files access point ARN"
  }

  assert {
    condition     = aws_lambda_function.this.file_system_config[0].local_mount_path == "/mnt/s3"
    error_message = "Local mount path does not match expected value"
  }

  assert {
    condition     = length(aws_iam_policy.s3_mount) == 1
    error_message = "S3 mount IAM policy should be created"
  }

  assert {
    condition     = length(aws_iam_role_policy_attachment.s3_mount) == 1
    error_message = "S3 mount IAM policy should be attached to the role"
  }
}
