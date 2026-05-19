variable "name" {
  description = "The base name for the AWS Backup resources"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_-]{1,50}$", var.name))
    error_message = "The name must be between 1 and 50 characters and can only contain alphanumeric characters, underscores, and hyphens."
  }
}

variable "kms_key_arn" {
  description = "The ARN of the KMS key to use for the backup vault. (Must be a CMK)"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:kms:[a-z0-9-]+:[0-9]{12}:key/.*$", var.kms_key_arn))
    error_message = "The kms_key_arn must be a valid AWS KMS key ARN."
  }
}

variable "vault_lock_configuration" {
  description = "Optional configuration for AWS Backup Vault Lock"
  type = object({
    changeable_for_days = optional(number)
    max_retention_days  = optional(number)
    min_retention_days  = optional(number)
  })
  default = null
}

variable "rules" {
  description = "A list of rules for the backup plan"
  type = list(object({
    rule_name           = string
    target_vault_name   = optional(string)
    schedule            = optional(string)
    start_window        = optional(number)
    completion_window   = optional(number)
    recovery_point_tags = optional(map(string))
    lifecycle = optional(object({
      cold_storage_after = optional(number)
      delete_after       = optional(number)
    }))
    copy_action = optional(list(object({
      destination_vault_arn = string
      lifecycle = optional(object({
        cold_storage_after = optional(number)
        delete_after       = optional(number)
      }))
    })))
  }))
}

variable "selection_resources" {
  description = "A list of strings that either contain Amazon Resource Names (ARNs) or flags of resources to assign to a backup plan"
  type        = list(string)
  default     = []
}

variable "selection_tags" {
  description = "A list of tag-based selection criteria"
  type = list(object({
    type  = string
    key   = string
    value = string
  }))
  default = []
}

variable "tags" {
  description = "A map of tags to assign to the resources. Required keys: environment, owner, project, cost_center."
  type        = map(string)

  validation {
    condition     = contains(keys(var.tags), "environment") && contains(keys(var.tags), "owner") && contains(keys(var.tags), "project") && contains(keys(var.tags), "cost_center")
    error_message = "The tags map must contain the following keys: environment, owner, project, cost_center."
  }
}
