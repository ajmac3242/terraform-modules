output "gateway_arn" {
  description = "The ARN of the Bedrock AgentCore Gateway."
  value       = aws_bedrockagentcore_gateway.this.gateway_arn
}

output "gateway_id" {
  description = "The ID of the Bedrock AgentCore Gateway."
  value       = aws_bedrockagentcore_gateway.this.gateway_id
}

output "gateway_url" {
  description = "The URL of the Bedrock AgentCore Gateway."
  value       = aws_bedrockagentcore_gateway.this.gateway_url
}

output "online_evaluation_config_arns" {
  description = "A map of Online Evaluation configuration ARNs."
  value       = { for k, v in aws_bedrockagentcore_online_evaluation_config.this : k => v.online_evaluation_config_arn }
}

output "browser_arns" {
  description = "A map of Browser ARNs."
  value       = { for k, v in aws_bedrockagentcore_browser.this : k => v.browser_arn }
}

output "gateway_target_ids" {
  description = "A map of Gateway Target IDs."
  value       = { for k, v in aws_bedrockagentcore_gateway_target.this : k => v.target_id }
}

output "tags" {
  description = "The tags applied to the resources."
  value       = aws_bedrockagentcore_gateway.this.tags
}
