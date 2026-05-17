output "guardrail_id" {
  description = "The unique identifier of the guardrail"
  value       = aws_bedrock_guardrail.this.guardrail_id
}

output "guardrail_arn" {
  description = "The ARN of the guardrail"
  value       = aws_bedrock_guardrail.this.guardrail_arn
}

output "guardrail_version" {
  description = "The version of the guardrail"
  value       = aws_bedrock_guardrail_version.this.version
}

output "tags" {
  description = "A map of tags assigned to the resource"
  value       = aws_bedrock_guardrail.this.tags
}
