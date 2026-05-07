output "agent_id" {
  description = "The unique identifier of the agent"
  value       = aws_bedrockagent_agent.this.id
}

output "agent_arn" {
  description = "The ARN of the agent"
  value       = aws_bedrockagent_agent.this.agent_arn
}

output "agent_alias_id" {
  description = "The unique identifier of the agent alias"
  value       = aws_bedrockagent_agent_alias.this.agent_alias_id
}

output "agent_role_arn" {
  description = "The ARN of the IAM role used by the agent"
  value       = var.agent_resource_role_arn
}

output "tags" {
  description = "A map of tags assigned to the agent"
  value       = aws_bedrockagent_agent.this.tags
}
