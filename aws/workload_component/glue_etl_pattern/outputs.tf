output "raw_bucket_arn" {
  description = "The ARN of the raw data S3 bucket"
  value       = module.raw_bucket.bucket_arn
}

output "processed_bucket_arn" {
  description = "The ARN of the processed data S3 bucket"
  value       = module.processed_bucket.bucket_arn
}

output "scripts_bucket_arn" {
  description = "The ARN of the scripts S3 bucket"
  value       = module.scripts_bucket.bucket_arn
}

output "glue_role_arn" {
  description = "The ARN of the Glue IAM role"
  value       = module.glue_role.role_arn
}

output "glue_database_name" {
  description = "The name of the Glue catalog database"
  value       = module.glue.database_name
}

output "glue_database_arn" {
  description = "The ARN of the Glue catalog database"
  value       = module.glue.database_arn
}

output "glue_crawler_name" {
  description = "The name of the Glue crawler"
  value       = module.glue.crawler_name
}

output "glue_crawler_arn" {
  description = "The ARN of the Glue crawler"
  value       = module.glue.crawler_arn
}

output "glue_job_name" {
  description = "The name of the Glue job"
  value       = module.glue.job_name
}

output "glue_job_arn" {
  description = "The ARN of the Glue job"
  value       = module.glue.job_arn
}

output "tags" {
  description = "The tags assigned to the resources"
  value       = var.tags
}
