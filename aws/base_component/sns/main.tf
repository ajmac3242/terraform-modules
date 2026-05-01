# Main SNS Topic resource
resource "aws_sns_topic" "this" {
  name              = var.name
  kms_master_key_id = var.kms_key_arn

  tags = var.tags
}
