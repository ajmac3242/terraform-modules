output "securityhub_id" {
  description = "The ID of the Security Hub account"
  value       = aws_securityhub_account.this.id
}

output "securityhub_arn" {
  description = "The ARN of the Security Hub account"
  value       = "arn:aws:securityhub:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:hub/default"
}

output "finding_aggregator_id" {
  description = "The ID of the finding aggregator"
  value       = try(aws_securityhub_finding_aggregator.this[0].id, null)
}
