# -----------------------------------------------------------------------------
# Exposure / Secure Defaults
# -----------------------------------------------------------------------------
output "s3_account_public_block_enabled" {
  description = "Whether the account-level S3 Public Access Block is enabled"
  value       = var.enable_s3_account_public_block
}

output "default_security_group_id" {
  description = "The ID of the hardened default security group, or null if vpc_id was not provided"
  value       = try(aws_default_security_group.this[0].id, null)
}

output "ec2_metadata_defaults_enabled" {
  description = "Whether the account-level EC2 metadata defaults (IMDSv2) are enabled"
  value       = var.enable_ec2_metadata_defaults
}

output "ebs_encryption_enabled" {
  description = "Whether account-level EBS encryption by default is enabled"
  value       = var.enable_ebs_encryption_by_default
}

# -----------------------------------------------------------------------------
# Identity Hardening
# -----------------------------------------------------------------------------
output "iam_password_policy_enabled" {
  description = "Whether the account-level IAM password policy is enabled"
  value       = var.enable_iam_password_policy
}

output "access_analyzer_arn" {
  description = "The ARN of the IAM Access Analyzer, or null if disabled"
  value       = try(aws_accessanalyzer_analyzer.this.arn, null)
}

# -----------------------------------------------------------------------------
# Threat Detection
# -----------------------------------------------------------------------------
output "guardduty_detector_id" {
  description = "The ID of the GuardDuty detector, or null if GuardDuty is disabled"
  value       = try(aws_guardduty_detector.this[0].id, null)
}

output "guardduty_detector_arn" {
  description = "The ARN of the GuardDuty detector, or null if GuardDuty is disabled"
  value       = try(aws_guardduty_detector.this[0].arn, null)
}

# -----------------------------------------------------------------------------
# Alternate Contacts
# -----------------------------------------------------------------------------
output "security_contact_email" {
  description = "The email address of the registered alternate security contact, or null if not set"
  value       = try(aws_account_alternate_contact.security[0].email_address, null)
}

output "billing_contact_email" {
  description = "The email address of the registered alternate billing contact, or null if not set"
  value       = try(aws_account_alternate_contact.billing[0].email_address, null)
}

output "operations_contact_email" {
  description = "The email address of the registered alternate operations contact, or null if not set"
  value       = try(aws_account_alternate_contact.operations[0].email_address, null)
}

output "support_role_arn" {
  description = "The ARN of the IAM Support role"
  value       = try(module.support_role[0].role_arn, null)
}

output "support_role_name" {
  description = "The name of the IAM Support role"
  value       = try(module.support_role[0].role_name, null)
}

output "tags" {
  description = "A map of tags assigned to the resources"
  value       = var.tags
}
