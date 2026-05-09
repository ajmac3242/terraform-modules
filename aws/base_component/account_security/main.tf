# Account-level security configurations
# This module enforces organizational security standards at the account/regional level.
# Designed for use in AWS Organization member accounts managed by Control Tower.
# CloudTrail, Config, and Security Hub are assumed to be managed centrally by the organization.

# -----------------------------------------------------------------------------
# 1. S3 Account-level Public Access Block
# Enforces that NO bucket in the account can be made public, regardless of
# individual bucket settings.
# -----------------------------------------------------------------------------
resource "aws_s3_account_public_access_block" "this" {
  count = var.enable_s3_account_public_block ? 1 : 0

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# -----------------------------------------------------------------------------
# 2. Default Security Group Hardening
# Removes all rules from the default security group in the specified VPC.
# Default security groups should never be used for actual traffic.
# -----------------------------------------------------------------------------
resource "aws_default_security_group" "this" {
  count  = var.vpc_id != null ? 1 : 0
  vpc_id = var.vpc_id

  # No ingress or egress rules defined = deny all

  tags = merge(var.tags, {
    Name = "default-sg-denied"
  })
}

# -----------------------------------------------------------------------------
# 3. EC2 Instance Metadata Defaults
# Note: Requires AWS Provider >= 5.71.0
# -----------------------------------------------------------------------------
resource "aws_ec2_instance_metadata_defaults" "this" {
  count = var.enable_ec2_metadata_defaults ? 1 : 0

  # Require IMDSv2 (session-token based) for all new instances
  http_tokens = "required"
  # Hop limit of 1 prevents metadata access from within containers
  http_put_response_hop_limit = var.ec2_metadata_hop_limit
  # Disable instance tags in metadata unless explicitly needed
  instance_metadata_tags = "disabled"
}

# -----------------------------------------------------------------------------
# 4. EBS Encryption by Default
# All new EBS volumes and snapshots will be encrypted.
# -----------------------------------------------------------------------------
resource "aws_ebs_encryption_by_default" "this" {
  count   = var.enable_ebs_encryption_by_default ? 1 : 0
  enabled = true
}

resource "aws_ebs_default_kms_key" "this" {
  count   = var.enable_ebs_encryption_by_default && var.ebs_kms_key_arn != null ? 1 : 0
  key_arn = var.ebs_kms_key_arn
}

# -----------------------------------------------------------------------------
# 5. IAM Account Password Policy
# Enforces strong password requirements for IAM users.
# -----------------------------------------------------------------------------
resource "aws_iam_account_password_policy" "this" {
  count = var.enable_iam_password_policy ? 1 : 0

  minimum_password_length        = var.password_policy_min_length
  require_lowercase_characters   = true
  require_numbers                = true
  require_symbols                = true
  require_uppercase_characters   = true
  allow_users_to_change_password = true
  max_password_age               = 90
  password_reuse_prevention      = 24
  hard_expiry                    = false
}

# -----------------------------------------------------------------------------
# 6. IAM Access Analyzer
# Continuously monitors resource policies to identify any resources shared
# with external entities (accounts, internet, etc.).
# -----------------------------------------------------------------------------
resource "aws_accessanalyzer_analyzer" "this" {
  count         = var.enable_access_analyzer ? 1 : 0
  analyzer_name = "account-access-analyzer"
  type          = "ACCOUNT"

  tags = var.tags
}

# -----------------------------------------------------------------------------
# 7. Amazon GuardDuty
# Account/region-level threat detection. Compatible with org-level GuardDuty
# delegated admin — member detectors are required even in org-managed setups.
# -----------------------------------------------------------------------------
resource "aws_guardduty_detector" "this" {
  count  = var.enable_guardduty ? 1 : 0
  enable = true

  tags = var.tags
}

resource "aws_guardduty_detector_feature" "s3_logs" {
  count       = var.enable_guardduty ? 1 : 0
  detector_id = aws_guardduty_detector.this[0].id
  name        = "S3_DATA_EVENTS"
  status      = "ENABLED"
}

resource "aws_guardduty_detector_feature" "kubernetes" {
  count       = var.enable_guardduty ? 1 : 0
  detector_id = aws_guardduty_detector.this[0].id
  name        = "EKS_AUDIT_LOGS"
  status      = var.enable_guardduty_kubernetes ? "ENABLED" : "DISABLED"
}

resource "aws_guardduty_detector_feature" "malware_protection" {
  count       = var.enable_guardduty ? 1 : 0
  detector_id = aws_guardduty_detector.this[0].id
  name        = "EBS_MALWARE_PROTECTION"
  status      = "ENABLED"
}

# -----------------------------------------------------------------------------
# 8. Account Alternate Contacts
# Registers security, billing, and operations contacts on the account.
# CIS Benchmark requires current contact details for all three personas.
# Use team/group mailboxes rather than individual addresses.
# -----------------------------------------------------------------------------
resource "aws_account_alternate_contact" "security" {
  count = var.security_contact_email != null ? 1 : 0

  alternate_contact_type = "SECURITY"
  name                   = var.security_contact_name
  email_address          = var.security_contact_email
  phone_number           = var.security_contact_phone
  title                  = var.security_contact_title
}

resource "aws_account_alternate_contact" "billing" {
  count = var.billing_contact_email != null ? 1 : 0

  alternate_contact_type = "BILLING"
  name                   = var.billing_contact_name
  email_address          = var.billing_contact_email
  phone_number           = var.billing_contact_phone
  title                  = var.billing_contact_title
}

resource "aws_account_alternate_contact" "operations" {
  count = var.operations_contact_email != null ? 1 : 0

  alternate_contact_type = "OPERATIONS"
  name                   = var.operations_contact_name
  email_address          = var.operations_contact_email
  phone_number           = var.operations_contact_phone
  title                  = var.operations_contact_title
}

# -----------------------------------------------------------------------------
# 9. EC2 Serial Console Access
# CIS Benchmark recommends disabling serial console access.
# -----------------------------------------------------------------------------
resource "aws_ec2_serial_console_access" "this" {
  enabled = var.enable_serial_console_access
}

# -----------------------------------------------------------------------------
# 10. IAM Support Role
# CIS Benchmark requires a support role with AWSSupportAccess policy.
# -----------------------------------------------------------------------------
module "support_role" {
  count  = var.create_support_role ? 1 : 0
  source = "../iam"

  role_name   = "aws-support-access-role"
  description = "Support role for AWS account management (CIS compliant)"
  tags        = var.tags

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
      }
    ]
  })

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AWSSupportAccess"
  ]
}

# -----------------------------------------------------------------------------
# Data sources
# -----------------------------------------------------------------------------
data "aws_region" "current" {}
data "aws_caller_identity" "current" {}
