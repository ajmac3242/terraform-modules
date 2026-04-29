output "knowledge_base_id" {
  description = "The ID of the knowledge base"
  value       = aws_bedrockagent_knowledge_base.this.id
}

output "knowledge_base_arn" {
  description = "The ARN of the knowledge base"
  value       = aws_bedrockagent_knowledge_base.this.arn
}

output "role_arn" {
  description = "The ARN of the IAM role used by the knowledge base"
  value       = module.iam_role.role_arn
}

output "role_name" {
  description = "The name of the IAM role used by the knowledge base"
  value       = module.iam_role.role_name
}
