# Main EventBridge Bus resource
resource "aws_cloudwatch_event_bus" "this" {
  count              = var.create_bus ? 1 : 0
  name               = var.name
  kms_key_identifier = var.kms_key_arn

  tags = var.tags
}

locals {
  bus_name = var.create_bus ? aws_cloudwatch_event_bus.this[0].name : (var.name != null ? var.name : "default")
}

# EventBridge Rules
resource "aws_cloudwatch_event_rule" "this" {
  for_each = var.rules

  name                = each.key
  description         = each.value.description
  event_bus_name      = local.bus_name
  event_pattern       = each.value.event_pattern
  schedule_expression = each.value.schedule_expression
  state               = each.value.state

  tags = var.tags
}

# EventBridge Targets
resource "aws_cloudwatch_event_target" "this" {
  for_each = var.targets

  rule           = aws_cloudwatch_event_rule.this[each.value.rule_name].name
  target_id      = split("/", each.key)[1]
  arn            = each.value.arn
  event_bus_name = local.bus_name
  role_arn       = each.value.role_arn
  input          = each.value.input

  dynamic "dead_letter_config" {
    for_each = each.value.dead_letter_arn != null ? [1] : []
    content {
      arn = each.value.dead_letter_arn
    }
  }
}
