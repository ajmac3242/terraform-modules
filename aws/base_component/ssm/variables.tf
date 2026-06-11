variable "name" {
  description = "The name of the SSM parameter"
  type        = string
}

variable "description" {
  description = "The description of the SSM parameter"
  type        = string
}

variable "value" {
  description = "The value of the SSM parameter"
  type        = string
  sensitive   = true
}

variable "kms_key_arn" {
  description = "The KMS key ARN to use for encryption"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:kms:[a-z0-9-]+:[0-9]{12}:key/[a-z0-9-]+$", var.kms_key_arn))
    error_message = "The KMS key ARN must be a valid AWS KMS key ARN."
  }
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
