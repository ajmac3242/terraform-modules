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

output "browser_arn" {
  description = "The ARN of the Bedrock AgentCore Browser tool."
  value       = try(aws_bedrockagentcore_browser.this[0].browser_arn, null)
}

output "browser_id" {
  description = "The ID of the Bedrock AgentCore Browser tool."
  value       = try(aws_bedrockagentcore_browser.this[0].browser_id, null)
}

output "target_ids" {
  description = "A map of gateway target IDs."
  value       = { for k, v in aws_bedrockagentcore_gateway_target.this : k => v.target_id }
}

output "tags" {
  description = "The tags applied to the gateway."
  value       = aws_bedrockagentcore_gateway.this.tags
}
