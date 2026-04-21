# Main VPC Endpoint resource (iterates over provided map)
resource "aws_vpc_endpoint" "this" {
  for_each = var.endpoints

  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.region}.${each.value.service}"
  vpc_endpoint_type = each.value.service_type

  # Interface specific settings
  security_group_ids  = each.value.service_type == "Interface" ? var.security_group_ids : null
  subnet_ids          = each.value.service_type == "Interface" ? var.subnet_ids : null
  private_dns_enabled = each.value.service_type == "Interface" ? each.value.private_dns_enabled : null

  # Gateway specific settings
  route_table_ids = each.value.service_type == "Gateway" ? var.route_table_ids : null

  tags = var.tags
}
