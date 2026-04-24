# Main EventBridge Bus resource
resource "aws_cloudwatch_event_bus" "this" {
  name       = var.name
  kms_key_identifier = var.kms_key_arn

  tags = var.tags
}
