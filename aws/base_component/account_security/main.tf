# Account-level security configurations
# This module enforces organizational security standards at the account/regional level.

# 1. S3 Account-level Public Access Block
# Enforces that NO bucket in the account can be made public, regardless of individual bucket settings.
resource "aws_s3_account_public_access_block" "this" {
  count = var.enable_s3_account_public_block ? 1 : 0

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# 2. Default Security Group Hardening
# Removes all rules from the default security group in the specified VPC.
# Default security groups should never be used for actual traffic.
resource "aws_default_security_group" "this" {
  count  = var.vpc_id != null ? 1 : 0
  vpc_id = var.vpc_id

  # No ingress or egress rules defined = deny all

  tags = merge(var.tags, {
    Name = "default-sg-denied"
  })
}

# 3. EC2 Instance Metadata Defaults
# Enforces IMDSv2 (tokens required) and sets a secure hop limit.
# Note: Requires AWS Provider >= 5.71.0
resource "aws_ec2_instance_metadata_defaults" "this" {
  count = var.enable_ec2_metadata_defaults ? 1 : 0

  http_tokens                 = "required"
  http_put_response_hop_limit = var.ec2_metadata_hop_limit
  http_endpoint               = "enabled"
  instance_metadata_tags      = "enabled"
}
