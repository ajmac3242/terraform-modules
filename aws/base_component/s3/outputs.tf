output "bucket_id" {
  description = "The name of the bucket"
  value       = aws_s3_bucket.this.id
}

output "bucket_arn" {
  description = "The ARN of the bucket"
  value       = aws_s3_bucket.this.arn
}

output "bucket_regional_domain_name" {
  description = "The bucket region-specific domain name"
  value       = aws_s3_bucket.this.bucket_regional_domain_name
}

output "kms_key_arn" {
  description = "The ARN of the KMS key used for encryption"
  value       = local.kms_key_arn
}

output "kms_key_id" {
  description = "The ID of the KMS key used for encryption"
  value       = var.existing_kms_key_arn != null ? var.existing_kms_key_arn : module.kms[0].key_id
}

output "tags" {
  description = "The tags assigned to the resource"
  value       = aws_s3_bucket.this.tags_all
}
