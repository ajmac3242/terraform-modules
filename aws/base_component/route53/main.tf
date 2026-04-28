# Route 53 Records resource
resource "aws_route53_record" "this" {
  for_each = { for r in var.records : "${r.name}_${r.type}" => r }

  zone_id = var.zone_id
  name    = each.value.name
  type    = each.value.type
  ttl     = try(each.value.ttl, null)
  records = try(each.value.records, null)

  dynamic "alias" {
    for_each = try(each.value.alias, null) != null ? [each.value.alias] : []
    content {
      name                   = alias.value.name
      zone_id                = alias.value.zone_id
      evaluate_target_health = alias.value.evaluate_target_health
    }
  }
}
