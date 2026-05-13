output "database_name" {
  description = "The name of the Glue catalog database"
  value       = aws_glue_catalog_database.this.name
}

output "database_arn" {
  description = "The ARN of the Glue catalog database"
  value       = aws_glue_catalog_database.this.arn
}

output "security_configuration_name" {
  description = "The name of the Glue security configuration"
  value       = aws_glue_security_configuration.this.name
}

output "crawler_name" {
  description = "The name of the Glue crawler"
  value       = length(aws_glue_crawler.this) > 0 ? aws_glue_crawler.this[0].name : null
}

output "crawler_arn" {
  description = "The ARN of the Glue crawler"
  value       = length(aws_glue_crawler.this) > 0 ? aws_glue_crawler.this[0].arn : null
}

output "job_name" {
  description = "The name of the Glue job"
  value       = length(aws_glue_job.this) > 0 ? aws_glue_job.this[0].name : null
}

output "job_arn" {
  description = "The ARN of the Glue job"
  value       = length(aws_glue_job.this) > 0 ? aws_glue_job.this[0].arn : null
}

output "tags" {
  description = "The tags assigned to the resources"
  value       = var.tags
}
