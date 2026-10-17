variable "name" {
  description = "The name of the trail"
  type        = string
}

variable "s3_bucket_name" {
  description = "The name of the S3 bucket to store logs"
  type        = string
}

variable "kms_key_arn" {
  description = "The ARN of the KMS key for encryption of trail logs"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:kms:[a-z0-9-]+:[0-9]{12}:key/[a-z0-9-]+$", var.kms_key_arn))
    error_message = "The kms_key_arn must be a valid AWS KMS key ARN."
  }
}

variable "is_multi_region_trail" {
  description = "Whether the trail is created in all regions or just in one region"
  type        = bool
  default     = true
}

variable "include_global_service_events" {
  description = "Whether the trail is publishing events from global services"
  type        = bool
  default     = true
}

variable "enable_log_file_validation" {
  description = "Whether log file integrity validation is enabled"
  type        = bool
  default     = true
}

variable "cloudwatch_logs_group_arn" {
  description = "The ARN of the CloudWatch Log Group to which CloudTrail logs will be delivered"
  type        = string
  default     = null
}

variable "cloudwatch_logs_role_arn" {
  description = "The ARN of the IAM role that CloudTrail uses to send logs to CloudWatch Logs"
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
