output "repository_arn" {
  description = "Full ARN of the repository"
  value       = aws_ecr_repository.this.arn
}

output "repository_url" {
  description = "The URL of the repository"
  value       = aws_ecr_repository.this.repository_url
}

output "repository_name" {
  description = "The name of the repository"
  value       = aws_ecr_repository.this.name
}

output "kms_key_arn" {
  description = "The ARN of the KMS key used for encryption"
  value       = local.kms_key_arn
}

output "tags" {
  description = "A map of tags assigned to the resource"
  value       = aws_ecr_repository.this.tags_all
}
