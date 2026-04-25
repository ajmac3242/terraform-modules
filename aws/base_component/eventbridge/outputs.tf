output "event_bus_arn" {
  description = "The ARN of the event bus"
  value       = var.create_bus ? aws_cloudwatch_event_bus.this[0].arn : null
}

output "event_bus_name" {
  description = "The name of the event bus"
  value       = local.bus_name
}

output "rule_arns" {
  description = "A map of rule names to their ARNs"
  value       = { for k, v in aws_cloudwatch_event_rule.this : k => v.arn }
}

output "target_ids" {
  description = "A list of target IDs"
  value       = [for k, v in aws_cloudwatch_event_target.this : v.target_id]
}
