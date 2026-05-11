# Enterprise Multicloud Networking pattern
# Composes aws_interconnect with Transit Gateway

module "interconnect" {
  source = "../../base_component/aws_interconnect"

  name             = var.name
  cloud_provider   = var.cloud_provider
  bandwidth        = var.bandwidth
  location         = var.location
  amazon_side_asn  = var.amazon_side_asn
  vlan             = var.vlan
  customer_bgp_asn = var.customer_bgp_asn
  vif_type         = "TRANSIT"

  tags = var.tags
}

resource "aws_ec2_transit_gateway" "this" {
  description = "Regional hub for multicloud connectivity: ${var.name}"

  amazon_side_asn                 = var.amazon_side_asn
  auto_accept_shared_attachments  = "enable"
  default_route_table_association = "enable"
  default_route_table_propagation = "enable"
  vpn_ecmp_support                = "enable"

  tags = var.tags
}

resource "aws_dx_gateway_association" "this" {
  dx_gateway_id         = module.interconnect.gateway_id
  associated_gateway_id = aws_ec2_transit_gateway.this.id

  allowed_prefixes = var.allowed_prefixes
}

resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/tgw/${var.name}"
  retention_in_days = 30
  kms_key_id        = var.kms_key_arn

  tags = var.tags
}

resource "aws_flow_log" "this" {
  iam_role_arn    = module.tgw_log_role.role_arn
  log_destination = aws_cloudwatch_log_group.this.arn
  traffic_type    = "ALL"
  transit_gateway_id = aws_ec2_transit_gateway.this.id

  tags = var.tags
}

module "tgw_log_role" {
  source = "../../base_component/iam"

  role_name   = "tgw-logs-${var.name}"
  description = "IAM role for Transit Gateway Flow Logs delivery to CloudWatch"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "vpc-flow-logs.amazonaws.com"
        }
      },
    ]
  })

  tags = var.tags
}

resource "aws_iam_role_policy" "tgw_logs" {
  name = "tgw-logs-policy"
  role = module.tgw_log_role.role_name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams"
        ]
        Resource = "${aws_cloudwatch_log_group.this.arn}:*"
      }
    ]
  })
}
