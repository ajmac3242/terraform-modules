# VPC Lattice Service Network
resource "aws_vpclattice_service_network" "this" {
  name      = var.name
  auth_type = var.auth_type

  tags = var.tags
}

# VPC Lattice Service
resource "aws_vpclattice_service" "this" {
  name      = var.name
  auth_type = var.auth_type

  tags = var.tags
}

# Associate Service Network with VPC
resource "aws_vpclattice_service_network_vpc_association" "this" {
  service_network_identifier = aws_vpclattice_service_network.this.id
  vpc_identifier             = var.vpc_id

  tags = var.tags
}

# Associate Service with Service Network
resource "aws_vpclattice_service_network_service_association" "this" {
  service_network_identifier = aws_vpclattice_service_network.this.id
  service_identifier         = aws_vpclattice_service.this.id

  tags = var.tags
}

# Auth Policy for Service Network (Least Privilege)
resource "aws_vpclattice_auth_policy" "this" {
  count               = var.auth_type == "AWS_IAM" ? 1 : 0
  resource_identifier = aws_vpclattice_service_network.this.arn
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "vpc-lattice-svcs:Invoke"
        Effect    = "Allow"
        Principal = "*"
        Resource  = "*"
        Condition = {
          StringEquals = {
            "vpc-lattice-svcs:ServiceNetworkArn" = aws_vpclattice_service_network.this.arn
          }
        }
      }
    ]
  })
}

# CloudWatch Log Group for Access Logs (CMK Encrypted)
resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/vpc-lattice/${var.name}"
  retention_in_days = 30
  kms_key_id        = var.kms_key_arn

  tags = var.tags
}

# Access Log Subscription
resource "aws_vpclattice_access_log_subscription" "this" {
  resource_identifier = aws_vpclattice_service_network.this.arn
  destination_arn     = aws_cloudwatch_log_group.this.arn
}
