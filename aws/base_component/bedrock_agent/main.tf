# aws_bedrockagent_agent
resource "aws_bedrockagent_agent" "this" {
  agent_name                  = var.agent_name
  foundation_model            = var.foundation_model
  instruction                 = var.instruction
  agent_resource_role_arn     = var.agent_resource_role_arn
  customer_encryption_key_arn = var.kms_key_arn

  tags = var.tags
}

# aws_bedrockagent_agent_alias
resource "aws_bedrockagent_agent_alias" "this" {
  agent_alias_name = "default"
  agent_id         = aws_bedrockagent_agent.this.agent_id

  tags = var.tags
}
