output "securityhub_id" {
  description = "The ID of the Security Hub account"
  value       = aws_securityhub_account.this.id
}

output "finding_aggregator_id" {
  description = "The ID of the finding aggregator"
  value       = try(aws_securityhub_finding_aggregator.this[0].id, null)
}
