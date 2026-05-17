output "queue_arn" {
  description = "The ARN of the SQS queue"
  value       = aws_sqs_queue.this.arn
}

output "queue_url" {
  description = "The URL of the SQS queue"
  value       = aws_sqs_queue.this.id
}

output "dlq_arn" {
  description = "The ARN of the dead-letter queue"
  value       = var.use_dead_letter_queue ? aws_sqs_queue.dlq[0].arn : null
}

output "tags" {
  description = "A map of tags assigned to the resource"
  value       = aws_sqs_queue.this.tags_all
}
