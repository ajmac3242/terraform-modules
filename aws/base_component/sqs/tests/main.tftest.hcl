variables {
  name        = "test-queue"
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

run "valid_queue_creation" {
  command = plan

  assert {
    condition     = aws_sqs_queue.this.name == var.name
    error_message = "SQS queue name does not match expected value"
  }

  assert {
    condition     = aws_sqs_queue.this.kms_master_key_id == var.kms_key_arn
    error_message = "KMS key ARN does not match expected value"
  }

  assert {
    condition     = aws_sqs_queue.this.tags["environment"] == "test" && aws_sqs_queue.this.tags["owner"] == "test-owner" && aws_sqs_queue.this.tags["project"] == "test-project" && aws_sqs_queue.this.tags["cost_center"] == "test-cc"
    error_message = "Mandatory tags are missing or incorrect on SQS queue"
  }
}

run "valid_queue_with_dlq" {
  command = plan

  variables {
    use_dead_letter_queue = true
  }

  assert {
    condition     = length(aws_sqs_queue.dlq) == 1
    error_message = "Expected 1 dead-letter queue"
  }
}
