# Route 53 Records resource
resource "aws_route53_record" "this" {
  for_each = { for r in var.records : "${r.name}_${r.type}" => r }

  zone_id = var.zone_id
  name    = each.value.name
  type    = each.value.type
  ttl     = each.value.ttl
  records = each.value.records
}
