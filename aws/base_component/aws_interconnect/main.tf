# AWS Interconnect Module (Multicloud L3 Networking)
# Standardizing connectivity to OCI and Azure

resource "aws_dx_gateway" "this" {
  name            = var.name
  amazon_side_asn = var.amazon_side_asn
}

# Interconnect for multicloud L3 connectivity.
# Using standard DX Gateway as the foundation for L3 routing.

resource "aws_dx_connection" "this" {
  name            = "${var.name}-connection"
  bandwidth       = var.bandwidth
  location        = var.location
  provider_name   = var.cloud_provider
  encryption_mode = "must_encrypt" # Enforcing MACsec encryption for transit data

  tags = var.tags
}

resource "aws_dx_private_virtual_interface" "this" {
  connection_id = aws_dx_connection.this.id

  name           = "${var.name}-vif"
  vlan           = var.vlan
  address_family = "ipv4"
  bgp_asn        = var.customer_bgp_asn

  dx_gateway_id = aws_dx_gateway.this.id

  tags = var.tags
}
