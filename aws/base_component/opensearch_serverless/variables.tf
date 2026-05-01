variable "name" {
  description = "The name of the OpenSearch Serverless collection (3-21 chars, lowercase alphanumeric and hyphens)"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]{3,21}$", var.name))
    error_message = "The name must be between 3 and 21 characters, contain only lowercase alphanumeric characters and hyphens. This ensures associated security policy names stay within the 32-character limit."
  }
}

variable "kms_key_arn" {
  description = "The ARN of the KMS key for encryption at rest"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:kms:[a-z0-9-]+:[0-9]{12}:key/.*$", var.kms_key_arn))
    error_message = "The kms_key_arn must be a valid KMS key ARN."
  }
}

variable "vpc_endpoint_ids" {
  description = "A list of VPC Endpoint IDs allowed to access the collection"
  type        = list(string)
  default     = []
}

variable "data_access_principals" {
  description = "A list of IAM principal ARNs allowed to access the data in the collection"
  type        = list(string)
}

variable "tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)

  validation {
    condition     = contains(keys(var.tags), "environment") && contains(keys(var.tags), "owner") && contains(keys(var.tags), "project") && contains(keys(var.tags), "cost_center")
    error_message = "The tags map must contain the following keys: environment, owner, project, cost_center."
  }
}
