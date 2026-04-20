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

variable "key_id" {
  description = "The KMS key ID or ARN to use for encryption"
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)

  validation {
    condition     = contains(keys(var.tags), "environment") && contains(keys(var.tags), "owner") && contains(keys(var.tags), "project") && contains(keys(var.tags), "cost_center")
    error_message = "The tags map must contain the following keys: environment, owner, project, cost_center."
  }
}
