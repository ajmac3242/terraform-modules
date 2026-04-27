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
