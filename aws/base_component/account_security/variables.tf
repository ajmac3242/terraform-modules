# -----------------------------------------------------------------------------
# General
# -----------------------------------------------------------------------------
variable "tags" {
  description = "A map of tags to assign to the resources. Required keys: environment, owner, project, cost_center."
  type        = map(string)

  validation {
    condition     = alltrue([for k in ["environment", "owner", "project", "cost_center"] : contains(keys(var.tags), k)])
    error_message = "The tags map must contain environment, owner, project, and cost_center keys."
  }
}



# -----------------------------------------------------------------------------
# S3 Account-level Public Access Block
# -----------------------------------------------------------------------------
variable "enable_s3_account_public_block" {
  description = "Whether to enable the account-level S3 Public Access Block"
  type        = bool
  default     = true
}

# -----------------------------------------------------------------------------
# Default Security Group Hardening
# -----------------------------------------------------------------------------
variable "vpc_id" {
  description = "The ID of the VPC to harden the default security group. If null, this resource is skipped."
  type        = string
  default     = null
}

# -----------------------------------------------------------------------------
# EC2 Instance Metadata Defaults
# -----------------------------------------------------------------------------
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

# -----------------------------------------------------------------------------
# EBS Encryption by Default
# -----------------------------------------------------------------------------
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
    condition     = var.ebs_kms_key_arn == null || can(regex("^arn:aws:kms:[a-z0-9-]+:[0-9]{12}:key/[a-z0-9-]+$", var.ebs_kms_key_arn))
    error_message = "The ebs_kms_key_arn must be a valid KMS key ARN."
  }
}

# -----------------------------------------------------------------------------
# IAM Account Password Policy
# -----------------------------------------------------------------------------
variable "enable_iam_password_policy" {
  description = "Whether to enable the account-level IAM password policy"
  type        = bool
  default     = true
}

variable "password_policy_min_length" {
  description = "Minimum length to require for IAM user passwords. AWS minimum is 6; CIS recommends 14+."
  type        = number
  default     = 14
}

# -----------------------------------------------------------------------------
# EC2 Serial Console Access
# -----------------------------------------------------------------------------
variable "enable_serial_console_access" {
  description = "Whether to enable EC2 serial console access. CIS recommends false."
  type        = bool
  default     = false
}

# -----------------------------------------------------------------------------
# IAM Support Role
# -----------------------------------------------------------------------------
variable "create_support_role" {
  description = "Whether to create the CIS-required IAM Support role"
  type        = bool
  default     = true
}

# -----------------------------------------------------------------------------
# IAM Access Analyzer
# -----------------------------------------------------------------------------
variable "enable_access_analyzer" {
  description = "Whether to enable IAM Access Analyzer for the account"
  type        = bool
  default     = true
}

# -----------------------------------------------------------------------------
# Amazon GuardDuty
# Member-account detectors are required even when a GuardDuty org delegated
# admin is managing findings centrally.
# -----------------------------------------------------------------------------
variable "enable_guardduty" {
  description = "Whether to enable Amazon GuardDuty for the account/region"
  type        = bool
  default     = true
}

variable "enable_guardduty_kubernetes" {
  description = "Whether to enable GuardDuty Kubernetes Audit Log monitoring. Set to false in accounts where EKS is not used."
  type        = bool
  default     = true
}

# -----------------------------------------------------------------------------
# Alternate Contacts
# AWS allows exactly one SECURITY, BILLING, and OPERATIONS contact per account.
# Use team/group mailboxes rather than individual addresses.
# CIS Benchmark requires current contact details for all three personas.
# -----------------------------------------------------------------------------

# Security contact
variable "security_contact_name" {
  description = "Full name of the alternate security contact for the AWS account"
  type        = string
  default     = null
}

variable "security_contact_email" {
  description = "Email address of the alternate security contact. When non-null, the contact record is created. Use a team/group mailbox."
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
  description = "Title or role of the alternate security contact"
  type        = string
  default     = "Security Team"
}

# Billing contact
variable "billing_contact_name" {
  description = "Full name of the alternate billing contact for the AWS account"
  type        = string
  default     = null
}

variable "billing_contact_email" {
  description = "Email address of the alternate billing contact. When non-null, the contact record is created. Use a team/group mailbox."
  type        = string
  default     = null

  validation {
    condition     = var.billing_contact_email == null || can(regex("^[^@]+@[^@]+\\.[^@]+$", var.billing_contact_email))
    error_message = "billing_contact_email must be a valid email address."
  }
}

variable "billing_contact_phone" {
  description = "Phone number of the alternate billing contact (E.164 format recommended, e.g. +15555550100)"
  type        = string
  default     = null
}

variable "billing_contact_title" {
  description = "Title or role of the alternate billing contact"
  type        = string
  default     = "Billing Team"
}

# Operations contact
variable "operations_contact_name" {
  description = "Full name of the alternate operations contact for the AWS account"
  type        = string
  default     = null
}

variable "operations_contact_email" {
  description = "Email address of the alternate operations contact. When non-null, the contact record is created. Use a team/group mailbox."
  type        = string
  default     = null

  validation {
    condition     = var.operations_contact_email == null || can(regex("^[^@]+@[^@]+\\.[^@]+$", var.operations_contact_email))
    error_message = "operations_contact_email must be a valid email address."
  }
}

variable "operations_contact_phone" {
  description = "Phone number of the alternate operations contact (E.164 format recommended, e.g. +15555550100)"
  type        = string
  default     = null
}

variable "operations_contact_title" {
  description = "Title or role of the alternate operations contact"
  type        = string
  default     = "Operations Team"
}

variable "aws_account_id" {
  description = "The AWS account ID"
  type        = string
  default     = null
}
