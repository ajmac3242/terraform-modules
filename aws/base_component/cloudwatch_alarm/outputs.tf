output "alarm_arns" {
  description = "A map of alarm names to their ARNs"
  value       = { for k, v in aws_cloudwatch_metric_alarm.this : k => v.arn }
}

output "alarm_ids" {
  description = "A map of alarm names to their IDs"
  value       = { for k, v in aws_cloudwatch_metric_alarm.this : k => v.id }
}

output "alarm_names" {
  description = "A list of alarm names"
  value       = keys(aws_cloudwatch_metric_alarm.this)
}

output "tags" {
  description = "A map of tags assigned to the resources"
  value       = var.tags
}
