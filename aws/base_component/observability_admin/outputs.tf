output "rule_arn" {
  description = "The ARN of the telemetry rule"
  value       = aws_observabilityadmin_telemetry_rule.this.rule_arn
}

output "rule_name" {
  description = "The name of the telemetry rule"
  value       = aws_observabilityadmin_telemetry_rule.this.rule_name
}

output "tags" {
  description = "A map of tags assigned to the resource"
  value       = aws_observabilityadmin_telemetry_rule.this.tags_all
}
