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

output "guardduty_detector_id" {
  description = "The ID of the GuardDuty detector, or null if GuardDuty is disabled"
  value       = try(aws_guardduty_detector.this[0].id, null)
}

output "guardduty_detector_arn" {
  description = "The ARN of the GuardDuty detector, or null if GuardDuty is disabled"
  value       = try(aws_guardduty_detector.this[0].arn, null)
}

output "cloudtrail_arn" {
  description = "The ARN of the CloudTrail trail, or null if CloudTrail is disabled"
  value       = try(aws_cloudtrail.this[0].arn, null)
}

output "cloudtrail_log_group_name" {
  description = "Name of the CloudWatch log group receiving CloudTrail events"
  value       = try(aws_cloudwatch_log_group.cloudtrail[0].name, null)
}

output "securityhub_enabled" {
  description = "Whether Security Hub has been enabled for this account"
  value       = var.enable_security_hub
}

output "config_recorder_name" {
  description = "Name of the AWS Config configuration recorder, or null if Config is disabled"
  value       = try(aws_config_configuration_recorder.this[0].name, null)
}

output "access_analyzer_arn" {
  description = "The ARN of the IAM Access Analyzer, or null if disabled"
  value       = try(aws_accessanalyzer_analyzer.this[0].arn, null)
}
