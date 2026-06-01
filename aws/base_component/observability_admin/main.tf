resource "aws_observabilityadmin_telemetry_rule" "this" {
  count     = var.is_organization_rule ? 0 : 1
  rule_name = var.rule_name

  rule {
    telemetry_type = var.telemetry_type
    resource_type  = var.resource_type
  }

  tags = var.tags
}

resource "aws_observabilityadmin_telemetry_rule_for_organization" "this" {
  count     = var.is_organization_rule ? 1 : 0
  rule_name = var.rule_name

  rule {
    telemetry_type = var.telemetry_type
    resource_type  = var.resource_type
  }

  tags = var.tags
}
