variable "name" {
  description = "The name prefix for the ETL pattern resources"
  type        = string
}

variable "kms_key_arn" {
  description = "The ARN of the KMS CMK to use for all encryption"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:kms:[a-z0-9-]+:[0-9]{12}:key/.*$", var.kms_key_arn))
    error_message = "The kms_key_arn must be a valid AWS KMS key ARN."
  }
}

variable "vpc_config" {
  description = "VPC configuration for the Glue job"
  type = object({
    subnet_ids         = list(string)
    security_group_ids = list(string)
  })
}

variable "tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)

  validation {
    condition     = contains(keys(var.tags), "environment") && contains(keys(var.tags), "owner") && contains(keys(var.tags), "project") && contains(keys(var.tags), "cost_center")
    error_message = "The tags map must contain the following keys: environment, owner, project, cost_center."
  }
}

variable "etl_script_path" {
  description = "Local path to the ETL script to upload to S3"
  type        = string
}
