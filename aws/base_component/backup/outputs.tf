output "vault_arn" {
  description = "The ARN of the backup vault"
  value       = aws_backup_vault.this.arn
}

output "vault_id" {
  description = "The name of the backup vault"
  value       = aws_backup_vault.this.id
}

output "plan_id" {
  description = "The ID of the backup plan"
  value       = aws_backup_plan.this.id
}

output "plan_arn" {
  description = "The ARN of the backup plan"
  value       = aws_backup_plan.this.arn
}

output "role_arn" {
  description = "The ARN of the IAM role used for AWS Backup"
  value       = module.backup_iam_role.role_arn
}

output "tags" {
  description = "A map of tags assigned to the resources"
  value       = aws_backup_vault.this.tags
}
