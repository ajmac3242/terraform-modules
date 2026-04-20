variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9.-]{3,63}$", var.bucket_name))
    error_message = "The bucket_name must be between 3 and 63 characters and can only contain lowercase letters, numbers, dots, and dashes."
  }
}

variable "existing_kms_key_arn" {
  description = "The ARN of an existing KMS CMK to use for SSE-KMS."
  type        = string
}

variable "versioning_enabled" {
  description = "Indicates whether versioning is enabled for the S3 bucket"
  type        = bool
  default     = true
}

variable "enable_access_logging" {
  description = "Indicates whether access logging is enabled for the S3 bucket"
  type        = bool
  default     = false
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

variable "tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)

  validation {
    condition     = contains(keys(var.tags), "environment") && contains(keys(var.tags), "owner") && contains(keys(var.tags), "project") && contains(keys(var.tags), "cost_center")
    error_message = "The tags map must contain the following keys: environment, owner, project, cost_center."
  }
}
