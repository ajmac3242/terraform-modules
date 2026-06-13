variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9.-]{3,63}$", var.bucket_name))
    error_message = "The bucket_name must be between 3 and 63 characters and can only contain lowercase letters, numbers, dots, and dashes."
  }
}

variable "existing_kms_key_arn" {
  description = "The ARN of an existing KMS CMK to use for SSE-KMS. If null, a new key will be created."
  type        = string
  default     = null

  validation {
    condition     = var.existing_kms_key_arn == null || can(regex("^arn:aws:kms:[a-z0-9-]+:[0-9]{12}:key/[a-z0-9-]+$", var.existing_kms_key_arn))
    error_message = "The existing_kms_key_arn must be a valid AWS KMS key ARN (arn:aws:kms:region:account:key/key-id)."
  }
}

variable "versioning_enabled" {
  description = "Indicates whether versioning is enabled for the S3 bucket"
  type        = bool
  default     = true
}

variable "enable_access_logging" {
  description = "Indicates whether access logging is enabled for the S3 bucket"
  type        = bool
  default     = true
}

variable "log_bucket_id" {
  description = "The ID of the S3 bucket to receive access logs"
  type        = string
  default     = null
}

variable "force_destroy" {
  description = "Indicates whether all objects should be deleted from the bucket when the bucket is destroyed"
  type        = bool
  default     = false
}

variable "lifecycle_rules" {
  description = "A list of lifecycle rules for the S3 bucket"
  type        = any
  default     = []
}

variable "aws_account_id" {
  description = "The AWS Account ID to support tests/mocking"
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

variable "additional_policy_document" {
  description = "An additional IAM policy document in JSON format to merge with the default SSL-only policy"
  type        = string
  default     = null
}

# Validation to ensure log_bucket_id is provided if access logging is enabled
# Using a null resource or local variable for complex validation if needed,
# but Terraform 1.5+ allows check blocks or we can use a local with an error.
# For simplicity in this module, we'll use a precondition in main.tf if possible,
# but let's try a validation block on a local.
