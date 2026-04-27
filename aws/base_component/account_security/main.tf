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

# 4. EBS Encryption by Default
# Enforces that all new EBS volumes are encrypted at rest.
resource "aws_ebs_encryption_by_default" "this" {
  count   = var.enable_ebs_encryption_by_default ? 1 : 0
  enabled = true
}

# Sets the default KMS key for EBS encryption.
resource "aws_ebs_default_kms_key" "this" {
  count       = var.enable_ebs_encryption_by_default && var.ebs_kms_key_arn != null ? 1 : 0
  key_arn     = var.ebs_kms_key_arn
  depends_on  = [aws_ebs_encryption_by_default.this]
}

# 5. IAM Account Password Policy
# Enforces strong passwords for IAM users in the account.
resource "aws_iam_account_password_policy" "this" {
  count = var.enable_iam_password_policy ? 1 : 0

  minimum_password_length        = var.password_policy_min_length
  require_lowercase_characters   = true
  require_numbers                = true
  require_uppercase_characters   = true
  require_symbols                = true
  allow_users_to_change_password = true
  password_reuse_prevention      = 24
  max_password_age               = 90
}

# 6. IAM Access Analyzer
# Monitors the account for resources that are shared with external entities.
resource "aws_accessanalyzer_analyzer" "this" {
  count = var.enable_access_analyzer ? 1 : 0

  analyzer_name = "${var.tags["project"]}-analyzer"
  type          = "ACCOUNT"

  tags = var.tags
}

# ---------------------------------------------------------------------------
# 7. GuardDuty
# Threat-intelligence-driven anomaly detection for the account.
# Enabling S3, Kubernetes, and Malware Protection sub-features gives the
# broadest coverage with no additional agent required.
# ---------------------------------------------------------------------------
resource "aws_guardduty_detector" "this" {
  count  = var.enable_guardduty ? 1 : 0
  enable = true

  datasources {
    s3_logs {
      enable = true
    }
    kubernetes {
      audit_logs {
        enable = var.enable_guardduty_kubernetes
      }
    }
    malware_protection {
      scan_ec2_instance_with_findings {
        ebs_volumes {
          enable = true
        }
      }
    }
  }

  tags = var.tags
}

# ---------------------------------------------------------------------------
# 8. CloudTrail — Account-wide Management Event Logging
# Records every API call made in the account. Multi-region + global services
# ensures no activity is missed, including root account actions.
# Log file validation detects tampering; CloudWatch delivery enables alerting.
# ---------------------------------------------------------------------------
resource "aws_cloudwatch_log_group" "cloudtrail" {
  count             = var.enable_cloudtrail ? 1 : 0
  name              = "/aws/cloudtrail/${var.tags["project"]}"
  retention_in_days = var.cloudtrail_log_retention_days
  kms_key_id        = var.cloudtrail_kms_key_arn

  tags = var.tags
}

resource "aws_iam_role" "cloudtrail_cw" {
  count = var.enable_cloudtrail ? 1 : 0
  name  = "${var.tags["project"]}-cloudtrail-cw-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "cloudtrail.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })

  tags = var.tags
}

resource "aws_iam_role_policy" "cloudtrail_cw" {
  count = var.enable_cloudtrail ? 1 : 0
  name  = "${var.tags["project"]}-cloudtrail-cw-policy"
  role  = aws_iam_role.cloudtrail_cw[0].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = ["logs:CreateLogStream", "logs:PutLogEvents"]
      # Scope to the specific log group for least-privilege
      Resource = "${aws_cloudwatch_log_group.cloudtrail[0].arn}:*"
    }]
  })
}

resource "aws_cloudtrail" "this" {
  count = var.enable_cloudtrail ? 1 : 0

  name                          = "${var.tags["project"]}-trail"
  s3_bucket_name                = var.cloudtrail_s3_bucket_name
  include_global_service_events = true
  is_multi_region_trail         = true
  enable_log_file_validation    = true
  enable_logging                = true

  # Ship to CloudWatch Logs for real-time alerting
  cloud_watch_logs_group_arn = "${aws_cloudwatch_log_group.cloudtrail[0].arn}:*"
  cloud_watch_logs_role_arn  = aws_iam_role.cloudtrail_cw[0].arn

  # Encrypt trail logs with a CMK when provided
  kms_key_id = var.cloudtrail_kms_key_arn

  tags = var.tags

  depends_on = [aws_iam_role_policy.cloudtrail_cw]
}

# ---------------------------------------------------------------------------
# 9. AWS Security Hub
# Aggregates findings from GuardDuty, Config, Inspector, Macie, and others
# into a single pane of glass. CIS and FSBP standards enforce a benchmark
# baseline automatically.
# ---------------------------------------------------------------------------
resource "aws_securityhub_account" "this" {
  count                        = var.enable_security_hub ? 1 : 0
  enable_default_standards     = false # Manage standards explicitly below
  auto_enable_controls         = true
  control_finding_generator    = "SECURITY_CONTROL"
}

resource "aws_securityhub_standards_subscription" "cis" {
  count         = var.enable_security_hub && var.enable_securityhub_cis ? 1 : 0
  standards_arn = "arn:aws:securityhub:::ruleset/cis-aws-foundations-benchmark/v/1.4.0"
  depends_on    = [aws_securityhub_account.this]
}

resource "aws_securityhub_standards_subscription" "fsbp" {
  count         = var.enable_security_hub && var.enable_securityhub_fsbp ? 1 : 0
  standards_arn = "arn:aws:securityhub:${data.aws_region.current.name}::standards/aws-foundational-security-best-practices/v/1.0.0"
  depends_on    = [aws_securityhub_account.this]
}

# ---------------------------------------------------------------------------
# 10. AWS Config — Configuration Recording
# Records resource configuration changes continuously. Required for drift
# detection, compliance evaluation, and incident forensics.
# ---------------------------------------------------------------------------
resource "aws_config_configuration_recorder" "this" {
  count    = var.enable_config ? 1 : 0
  name     = "${var.tags["project"]}-config-recorder"
  role_arn = aws_iam_role.config[0].arn

  recording_group {
    all_supported                 = true
    include_global_resource_types = true
  }

  depends_on = [aws_iam_role_policy_attachment.config_service_role]
}

resource "aws_config_delivery_channel" "this" {
  count          = var.enable_config ? 1 : 0
  name           = "${var.tags["project"]}-config-delivery"
  s3_bucket_name = var.config_s3_bucket_name
  depends_on     = [aws_config_configuration_recorder.this]
}

resource "aws_config_configuration_recorder_status" "this" {
  count      = var.enable_config ? 1 : 0
  name       = aws_config_configuration_recorder.this[0].name
  is_enabled = true
  depends_on = [aws_config_delivery_channel.this]
}

resource "aws_iam_role" "config" {
  count = var.enable_config ? 1 : 0
  name  = "${var.tags["project"]}-config-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "config.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "config_service_role" {
  count      = var.enable_config ? 1 : 0
  role       = aws_iam_role.config[0].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWS_ConfigRole"
}

# ---------------------------------------------------------------------------
# 11. Root Account MFA / Alternate Security Contact
# aws_account_alternate_contact ensures the security contact is always
# populated. An empty security contact is a CIS Benchmark finding.
# ---------------------------------------------------------------------------
resource "aws_account_alternate_contact" "security" {
  count = var.security_contact_email != null ? 1 : 0

  alternate_contact_type = "SECURITY"
  name                   = var.security_contact_name
  email_address          = var.security_contact_email
  phone_number           = var.security_contact_phone
  title                  = var.security_contact_title
}

# ---------------------------------------------------------------------------
# Data sources
# ---------------------------------------------------------------------------
data "aws_region" "current" {}
