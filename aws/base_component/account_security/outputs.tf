output "s3_account_public_block_enabled" {
  description = "Whether the account-level S3 Public Access Block is enabled"
  value       = var.enable_s3_account_public_block
}

output "default_security_group_id" {
  description = "The ID of the hardened default security group"
  value       = try(aws_default_security_group.this[0].id, null)
}

output "ec2_metadata_defaults_enabled" {
  description = "Whether the account-level EC2 metadata defaults are enabled"
  value       = var.enable_ec2_metadata_defaults
}
