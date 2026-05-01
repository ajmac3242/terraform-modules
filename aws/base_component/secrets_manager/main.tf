# Main Secrets Manager Secret resource
resource "aws_secretsmanager_secret" "this" {
  name        = var.name
  description = var.description
  kms_key_id  = var.kms_key_arn

  recovery_window_in_days = 30

  tags = var.tags
}
