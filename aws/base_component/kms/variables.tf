variable "name" {
  description = "The name of the KMS key (used for the alias)"
  type        = string
}

variable "description" {
  description = "The description of the KMS key"
  type        = string
}

variable "deletion_window_in_days" {
  description = "The waiting period, specified in number of days. After the time period ends, AWS KMS deletes the KMS key. (14-30)"
  type        = number
  default     = 30

  validation {
    condition     = var.deletion_window_in_days >= 14 && var.deletion_window_in_days <= 30
    error_message = "The deletion_window_in_days must be between 14 and 30 days."
  }
}

variable "admin_principal_arns" {
  description = "A list of IAM ARNs that are allowed to administer the KMS key"
  type        = list(string)
}

variable "usage_principal_arns" {
  description = "A list of IAM ARNs that are allowed to use the KMS key for cryptographic operations"
  type        = list(string)
}

variable "multi_region" {
  description = "Indicates whether the KMS key is a multi-Region (true) or regional (false) key"
  type        = bool
  default     = false
}



variable "tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)

  validation {
    condition     = contains(keys(var.tags), "environment") && contains(keys(var.tags), "owner") && contains(keys(var.tags), "project") && contains(keys(var.tags), "cost_center")
    error_message = "The tags map must contain the following keys: environment, owner, project, cost_center."
  }
}
