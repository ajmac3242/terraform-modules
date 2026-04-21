# SSM Parameter resource (SecureString by default)
resource "aws_ssm_parameter" "this" {
  name        = var.name
  description = var.description
  type        = "SecureString"
  value       = var.value
  key_id      = var.key_id

  tags = var.tags
}
