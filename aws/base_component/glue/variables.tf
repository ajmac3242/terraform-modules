variable "name" {
  description = "The name of the Glue components (database, crawler, job)"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_-]{1,64}$", var.name))
    error_message = "The name must be between 1 and 64 characters and can only contain alphanumeric characters, underscores, and hyphens."
  }
}

variable "kms_key_arn" {
  description = "The ARN of the KMS CMK to use for Glue encryption"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:kms:[a-z0-9-]+:[0-9]{12}:key/[a-z0-9-]+$", var.kms_key_arn))
    error_message = "The kms_key_arn must be a valid AWS KMS key ARN (arn:aws:kms:region:account:key/key-id)."
  }
}

variable "vpc_config" {
  description = "VPC configuration for Glue jobs (subnet_ids, security_group_ids)"
  type = object({
    subnet_ids         = list(string)
    security_group_ids = list(string)
  })
  default = null

  validation {
    condition     = var.vpc_config == null || length(try(var.vpc_config.subnet_ids, [])) > 0
    error_message = "At least one subnet ID must be provided in vpc_config."
  }
}

variable "role_arn" {
  description = "The ARN of the IAM role for Glue Crawler and Job"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:iam::[0-9]{12}:role/.*$", var.role_arn))
    error_message = "The role_arn must be a valid AWS IAM role ARN."
  }
}

variable "s3_targets" {
  description = "S3 targets for the Glue crawler"
  type = list(object({
    path = string
  }))
  default = []
}

variable "command_script_location" {
  description = "The S3 path to the Glue job script"
  type        = string
  default     = null
}

variable "tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)

  validation {
    condition     = contains(keys(var.tags), "environment") && contains(keys(var.tags), "owner") && contains(keys(var.tags), "project") && contains(keys(var.tags), "cost_center")
    error_message = "The tags map must contain the following keys: environment, owner, project, cost_center."
  }
}
