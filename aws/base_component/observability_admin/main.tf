resource "aws_observabilityadmin_telemetry_rule" "this" {
  rule_name = var.rule_name

  rule {
    telemetry_type = var.telemetry_type
    resource_type  = var.resource_type
  }

  tags = var.tags
}
