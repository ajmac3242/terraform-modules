output "policy_arn" {
  description = "The Amazon Resource Name (ARN) of the Resilience Hub resiliency policy."
  value       = aws_resiliencehub_resiliency_policy.this.arn
}

output "policy_id" {
  description = "The ID (ARN) of the Resilience Hub resiliency policy."
  value       = aws_resiliencehub_resiliency_policy.this.arn
}

output "policy_name" {
  description = "The name of the Resilience Hub resiliency policy."
  value       = aws_resiliencehub_resiliency_policy.this.name
}

output "tags" {
  description = "A map of tags assigned to the Resilience Hub resiliency policy."
  value       = aws_resiliencehub_resiliency_policy.this.tags
}
