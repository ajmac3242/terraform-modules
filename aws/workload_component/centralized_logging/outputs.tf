output "log_bucket_id" {
  description = "The ID of the centralized log bucket"
  value       = module.log_storage.bucket_id
}

output "log_bucket_arn" {
  description = "The ARN of the centralized log bucket"
  value       = module.log_storage.bucket_arn
}

output "kms_key_arn" {
  description = "The ARN of the KMS key used for log encryption"
  value       = module.log_storage.kms_key_arn
}

output "athena_workgroup_name" {
  description = "The name of the Athena workgroup"
  value       = module.log_analysis.workgroup_name
}

output "tags" {
  description = "A map of tags assigned to the resources"
  value       = var.tags
}
