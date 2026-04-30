variables {
  role_name   = "test-role"
  description = "A test role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  ]
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

run "valid_role_creation" {
  command = plan

  assert {
    condition     = aws_iam_role.this.name == var.role_name
    error_message = "IAM role name does not match expected value"
  }

  assert {
    condition     = aws_iam_role.this.description == var.description
    error_message = "IAM role description does not match expected value"
  }

  assert {
    condition     = length(aws_iam_role_policy_attachment.this) == 1
    error_message = "Expected 1 policy attachment"
  }

  assert {
    condition     = aws_iam_role.this.tags["environment"] == "test" && aws_iam_role.this.tags["owner"] == "test-owner" && aws_iam_role.this.tags["project"] == "test-project" && aws_iam_role.this.tags["cost_center"] == "test-cc"
    error_message = "Mandatory tags are missing or incorrect on IAM role"
  }
}
