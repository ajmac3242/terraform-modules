# Upstream VPC module call with organizational defaults
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = var.name
  cidr = var.cidr_block

  azs             = var.azs
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  enable_nat_gateway = var.enable_nat_gateway
  single_nat_gateway = var.single_nat_gateway

  # Enforce Flow Logs with mandatory CMK encryption
  enable_flow_log                          = true
  create_flow_log_cloudwatch_log_group     = true
  create_flow_log_cloudwatch_iam_role      = true
  flow_log_cloudwatch_log_group_kms_key_id = var.kms_key_arn

  tags = var.tags
}
