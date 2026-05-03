provider "aws" {
  region                      = "us-east-1"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true
  access_key                  = "mock_access_key"
  secret_key                  = "mock_secret_key"
}

variables {
  name       = "test-pipe"
  source_arn = "arn:aws:sqs:us-east-1:123456789012:source-queue"
  target_arn = "arn:aws:lambda:us-east-1:123456789012:function:target-function"

  tags = {
    environment = "test"
    owner       = "platform-team"
    project     = "standardization"
    cost_center = "12345"
  }
}

run "validate_pipe_creation" {
  command = plan

  assert {
    condition     = aws_pipes_pipe.this.name == "test-pipe"
    error_message = "Pipe name does not match expected value"
  }

  assert {
    condition     = aws_pipes_pipe.this.source == "arn:aws:sqs:us-east-1:123456789012:source-queue"
    error_message = "Pipe source does not match expected value"
  }

  assert {
    condition     = aws_pipes_pipe.this.target == "arn:aws:lambda:us-east-1:123456789012:function:target-function"
    error_message = "Pipe target does not match expected value"
  }

  assert {
    condition     = aws_pipes_pipe.this.tags["environment"] == "test"
    error_message = "Mandatory tag 'environment' is missing or incorrect"
  }

  assert {
    condition     = aws_pipes_pipe.this.tags["owner"] == "platform-team"
    error_message = "Mandatory tag 'owner' is missing or incorrect"
  }

  assert {
    condition     = aws_pipes_pipe.this.tags["project"] == "standardization"
    error_message = "Mandatory tag 'project' is missing or incorrect"
  }

  assert {
    condition     = aws_pipes_pipe.this.tags["cost_center"] == "12345"
    error_message = "Mandatory tag 'cost_center' is missing or incorrect"
  }

  assert {
    condition     = module.iam_role.tags["environment"] == "test"
    error_message = "IAM role mandatory tag 'environment' is missing or incorrect"
  }

  assert {
    condition     = module.iam_role.tags["owner"] == "platform-team"
    error_message = "IAM role mandatory tag 'owner' is missing or incorrect"
  }

  assert {
    condition     = module.iam_role.tags["project"] == "standardization"
    error_message = "IAM role mandatory tag 'project' is missing or incorrect"
  }

  assert {
    condition     = module.iam_role.tags["cost_center"] == "12345"
    error_message = "IAM role mandatory tag 'cost_center' is missing or incorrect"
  }
}
