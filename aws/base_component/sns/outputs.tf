output "topic_arn" {
  description = "The ARN of the SNS topic"
  value       = aws_sns_topic.this.arn
}

output "tags" {
  description = "A map of tags assigned to the resource"
  value       = aws_sns_topic.this.tags_all
}
