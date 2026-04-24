output "event_bus_arn" {
  description = "The ARN of the event bus"
  value       = aws_cloudwatch_event_bus.this.arn
}

output "event_bus_name" {
  description = "The name of the event bus"
  value       = aws_cloudwatch_event_bus.this.name
}
