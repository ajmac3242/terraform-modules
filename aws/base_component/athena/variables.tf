variable "name" {
  description = "Name of the Athena workgroup"
  type        = string
}

variable "description" {
  description = "Description of the Athena workgroup"
  type        = string
  default     = "Opinionated Athena workgroup"
}

variable "output_location" {
  description = "The S3 bucket location where query results are stored (e.g. s3://bucket-name/prefix/)"
  type        = string
}

variable "kms_key_arn" {
  description = "The ARN of the KMS key for encrypting query results"
  type        = string
}

variable "publish_cloudwatch_metrics_enabled" {
  description = "Whether to publish CloudWatch metrics for the workgroup"
  type        = bool
  default     = true
}

variable "bytes_scanned_cutoff_per_query" {
  description = "The maximum amount of data scanned per query in bytes"
  type        = number
  default     = null
}

variable "tags" {
  description = "Standard tags for all resources"
  type        = map(string)

  validation {
    condition     = contains(keys(var.tags), "environment") && contains(keys(var.tags), "owner") && contains(keys(var.tags), "project") && contains(keys(var.tags), "cost_center")
    error_message = "The tags map must include environment, owner, project, and cost_center."
  }
}
