# SQS Queue resource
resource "aws_sqs_queue" "this" {
  name                       = var.name
  visibility_timeout_seconds = var.visibility_timeout_seconds

  # Mandatory CMK encryption
  kms_master_key_id = var.kms_key_arn

  # Optional redrive policy for DLQ support
  redrive_policy = var.use_dead_letter_queue ? jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dlq[0].arn
    maxReceiveCount     = var.max_receive_count
  }) : null

  tags = var.tags
}

# Dead-letter queue resource
resource "aws_sqs_queue" "dlq" {
  count = var.use_dead_letter_queue ? 1 : 0
  name  = "${var.name}-dlq"

  kms_master_key_id = var.kms_key_arn

  tags = var.tags
}

# Local variable to support tests/mocking
locals {
  _unused_mock_account_id = var.aws_account_id
}
