variable "enable_s3_account_public_block" {
  description = "Whether to enable the account-level S3 Public Access Block"
  type        = bool
  default     = true
}

variable "vpc_id" {
  description = "The ID of the VPC to harden the default security group. If null, this resource is skipped."
  type        = string
  default     = null
}

variable "enable_ec2_metadata_defaults" {
  description = "Whether to enable account-level EC2 instance metadata defaults (IMDSv2 enforcement)"
  type        = bool
  default     = true
}

variable "ec2_metadata_hop_limit" {
  description = "The desired HTTP PUT response hop limit for instance metadata requests. Best practice is 1 to prevent hop to containers."
  type        = number
  default     = 1

  validation {
    condition     = var.ec2_metadata_hop_limit >= 1 && var.ec2_metadata_hop_limit <= 64
    error_message = "The hop limit must be between 1 and 64."
  }
}

variable "enable_ebs_encryption_by_default" {
  description = "Whether to enable account-level EBS encryption by default"
  type        = bool
  default     = true
}

variable "ebs_kms_key_arn" {
  description = "The ARN of the KMS key for default EBS encryption. If null, the default aws/ebs key is used."
  type        = string
  default     = null

  validation {
    condition     = var.ebs_kms_key_arn == null || can(regex("^arn:aws:kms:[a-z0-9-]+:[0-9]{12}:key/.*$", var.ebs_kms_key_arn))
    error_message = "The ebs_kms_key_arn must be a valid AWS KMS key ARN."
  }
}

variable "enable_iam_password_policy" {
  description = "Whether to enable the account-level IAM password policy"
  type        = bool
  default     = true
}

variable "password_policy_min_length" {
  description = "Minimum length to require for IAM user passwords"
  type        = number
  default     = 14

  validation {
    condition     = var.password_policy_min_length >= 8 && var.password_policy_min_length <= 128
    error_message = "The minimum password length must be between 8 and 128."
  }
}

variable "enable_access_analyzer" {
  description = "Whether to enable IAM Access Analyzer for the account"
  type        = bool
  default     = true
}

variable "tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)

  validation {
    condition     = contains(keys(var.tags), "environment") && contains(keys(var.tags), "owner") && contains(keys(var.tags), "project") && contains(keys(var.tags), "cost_center")
    error_message = "The tags map must contain the following keys: environment, owner, project, cost_center."
  }
}

variable "aws_account_id" {
  description = "The AWS Account ID to support tests/mocking"
  type        = string
  default     = null
}

# ---------------------------------------------------------------------------
# GuardDuty
# ---------------------------------------------------------------------------
variable "enable_guardduty" {
  description = "Whether to enable Amazon GuardDuty for the account/region"
  type        = bool
  default     = true
}

variable "enable_guardduty_kubernetes" {
  description = "Whether to enable GuardDuty Kubernetes Audit Log monitoring. Only relevant when enable_guardduty is true."
  type        = bool
  default     = true
}

# ---------------------------------------------------------------------------
# CloudTrail
# ---------------------------------------------------------------------------
variable "enable_cloudtrail" {
  description = "Whether to create an account-wide multi-region CloudTrail. Set to false if CloudTrail is managed by an org-level trail."
  type        = bool
  default     = true
}

variable "cloudtrail_s3_bucket_name" {
  description = "Name of the S3 bucket to receive CloudTrail logs. Required when enable_cloudtrail is true."
  type        = string
  default     = null

  validation {
    condition     = !var.enable_cloudtrail || var.cloudtrail_s3_bucket_name != null
    error_message = "cloudtrail_s3_bucket_name is required when enable_cloudtrail is true."
  }
}

variable "cloudtrail_kms_key_arn" {
  description = "ARN of the KMS key to encrypt CloudTrail logs and the CloudWatch log group. If null, encryption uses the default service key."
  type        = string
  default     = null

  validation {
    condition     = var.cloudtrail_kms_key_arn == null || can(regex("^arn:aws:kms:[a-z0-9-]+:[0-9]{12}:key/.*$", var.cloudtrail_kms_key_arn))
    error_message = "cloudtrail_kms_key_arn must be a valid KMS key ARN."
  }
}

variable "cloudtrail_log_retention_days" {
  description = "Retention period in days for the CloudTrail CloudWatch log group"
  type        = number
  default     = 365

  validation {
    condition     = contains([0, 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1096, 1827, 2192, 2557, 2922, 3288, 3653], var.cloudtrail_log_retention_days)
    error_message = "cloudtrail_log_retention_days must be a valid CloudWatch Logs retention value."
  }
}

# ---------------------------------------------------------------------------
# Security Hub
# ---------------------------------------------------------------------------
variable "enable_security_hub" {
  description = "Whether to enable AWS Security Hub for the account"
  type        = bool
  default     = true
}

variable "enable_securityhub_cis" {
  description = "Whether to subscribe to the CIS AWS Foundations Benchmark standard in Security Hub"
  type        = bool
  default     = true
}

variable "enable_securityhub_fsbp" {
  description = "Whether to subscribe to the AWS Foundational Security Best Practices standard in Security Hub"
  type        = bool
  default     = true
}

# ---------------------------------------------------------------------------
# AWS Config
# ---------------------------------------------------------------------------
variable "enable_config" {
  description = "Whether to enable AWS Config configuration recording for the account/region"
  type        = bool
  default     = true
}

variable "config_s3_bucket_name" {
  description = "Name of the S3 bucket to receive AWS Config snapshots and history. Required when enable_config is true."
  type        = string
  default     = null

  validation {
    condition     = !var.enable_config || var.config_s3_bucket_name != null
    error_message = "config_s3_bucket_name is required when enable_config is true."
  }
}

# ---------------------------------------------------------------------------
# Account Alternate Security Contact
# ---------------------------------------------------------------------------
variable "security_contact_name" {
  description = "Name of the alternate security contact for the AWS account (CIS benchmark requirement)"
  type        = string
  default     = null
}

variable "security_contact_email" {
  description = "Email address of the alternate security contact. When non-null, the contact record is created."
  type        = string
  default     = null

  validation {
    condition     = var.security_contact_email == null || can(regex("^[^@]+@[^@]+\\.[^@]+$", var.security_contact_email))
    error_message = "security_contact_email must be a valid email address."
  }
}

variable "security_contact_phone" {
  description = "Phone number of the alternate security contact (E.164 format recommended, e.g. +15555550100)"
  type        = string
  default     = null
}

variable "security_contact_title" {
  description = "Title/role of the alternate security contact"
  type        = string
  default     = "Security Team"
}
