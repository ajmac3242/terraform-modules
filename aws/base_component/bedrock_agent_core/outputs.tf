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

output "tags" {
  description = "The tags applied to the gateway."
  value       = aws_bedrockagentcore_gateway.this.tags
}
