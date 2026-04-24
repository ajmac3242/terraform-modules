output "alarm_arn" {
  description = "The ARN of the CloudWatch metric alarm"
  value       = aws_cloudwatch_metric_alarm.this.arn
}

output "alarm_id" {
  description = "The ID of the CloudWatch metric alarm"
  value       = aws_cloudwatch_metric_alarm.this.id
}
