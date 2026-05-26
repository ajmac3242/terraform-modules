output "rule_arn" {
  description = "The ARN of the telemetry rule"
  value       = var.enable_organization_rule ? aws_observabilityadmin_telemetry_rule_for_organization.this[0].rule_arn : aws_observabilityadmin_telemetry_rule.this[0].rule_arn
}

output "rule_name" {
  description = "The name of the telemetry rule"
  value       = var.enable_organization_rule ? aws_observabilityadmin_telemetry_rule_for_organization.this[0].rule_name : aws_observabilityadmin_telemetry_rule.this[0].rule_name
}

output "tags" {
  description = "A map of tags assigned to the resource"
  value       = var.enable_organization_rule ? aws_observabilityadmin_telemetry_rule_for_organization.this[0].tags_all : aws_observabilityadmin_telemetry_rule.this[0].tags_all
}
