output "user_pool_id" {
  description = "The ID of the User Pool"
  value       = aws_cognito_user_pool.this.id
}

output "user_pool_arn" {
  description = "The ARN of the User Pool"
  value       = aws_cognito_user_pool.this.arn
}

output "client_id" {
  description = "The ID of the User Pool Client"
  value       = aws_cognito_user_pool_client.this.id
}

output "tags" {
  description = "A map of tags assigned to the resource"
  value       = aws_cognito_user_pool.this.tags_all
}
