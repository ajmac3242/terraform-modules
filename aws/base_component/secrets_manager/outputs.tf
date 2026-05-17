output "secret_arn" {
  description = "The ARN of the secret"
  value       = aws_secretsmanager_secret.this.arn
}

output "secret_id" {
  description = "The ID of the secret"
  value       = aws_secretsmanager_secret.this.id
}

output "tags" {
  description = "A map of tags assigned to the resource"
  value       = aws_secretsmanager_secret.this.tags_all
}
