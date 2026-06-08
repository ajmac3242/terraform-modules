# -----------------------------------------------------------------------------
# Data sources
# -----------------------------------------------------------------------------
data "aws_caller_identity" "current" {}

# -----------------------------------------------------------------------------
# 1. S3 Public Access Block (Account Level)
# Enforces organization-wide security default for S3.
# -----------------------------------------------------------------------------
resource "aws_s3_account_public_access_block" "this" {
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# -----------------------------------------------------------------------------
# 2. Default Security Group Hardening
# Removes all ingress/egress rules from the default security group.
# -----------------------------------------------------------------------------
resource "aws_default_security_group" "this" {
  count  = var.vpc_id != null ? 1 : 0
  vpc_id = var.vpc_id

  tags = var.tags
}

# -----------------------------------------------------------------------------
# 3. EBS Encryption by Default
# Enforces regional default for EBS volume encryption.
# -----------------------------------------------------------------------------
resource "aws_ebs_encryption_by_default" "this" {
  enabled = true
}

resource "aws_ebs_default_kms_key" "this" {
  count       = var.ebs_kms_key_arn != null ? 1 : 0
  key_arn     = var.ebs_kms_key_arn
}

# -----------------------------------------------------------------------------
# 4. IAM Password Policy
# Enforces strong password requirements for IAM users.
# -----------------------------------------------------------------------------
resource "aws_iam_account_password_policy" "this" {
  minimum_password_length        = 14
  require_lowercase_characters   = true
  require_numbers                = true
  require_uppercase_characters   = true
  require_symbols                = true
  allow_users_to_change_password = true
  password_reuse_prevention      = 24
  max_password_age               = 90
}

# -----------------------------------------------------------------------------
# 5. Access Analyzer
# Monitors for resources shared outside the account or organization.
# -----------------------------------------------------------------------------
resource "aws_accessanalyzer_analyzer" "this" {
  analyzer_name = "account-analyzer"
  type          = "ACCOUNT"

  tags = var.tags
}

# -----------------------------------------------------------------------------
# 6. EC2 IMDSv2 Enforcement
# Mandates the use of IMDSv2 for all new instances in the region.
# -----------------------------------------------------------------------------
resource "aws_ec2_instance_metadata_defaults" "this" {
  http_tokens                 = "required"
  http_put_response_hop_limit = 1
}

# -----------------------------------------------------------------------------
# 7. GuardDuty
# Basic enablement of GuardDuty with recommended features.
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
