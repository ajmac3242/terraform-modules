variable "name" {
  description = "The name of the event bus. If null, the default bus is used."
  type        = string
  default     = null
}

variable "kms_key_arn" {
  description = "DEPRECATED: Use existing_kms_key_arn instead. The ARN of the KMS key for encryption."
  type        = string
  default     = null
}

variable "existing_kms_key_arn" {
  description = "The ARN of an existing KMS key to use for encryption. If null and create_bus is true, a new key will be created."
  type        = string
  default     = null
}

variable "create_bus" {
  description = "Whether to create a new event bus"
  type        = bool
  default     = true
}

variable "rules" {
  description = "A map of rules to create on the event bus"
  type = map(object({
    description         = optional(string)
    event_pattern       = optional(string)
    schedule_expression = optional(string)
    state               = optional(string, "ENABLED")
  }))
  default = {}

  validation {
    condition = alltrue([
      for r in var.rules : contains(["ENABLED", "DISABLED", "ENABLED_WITH_ALL_CLOUDTRAIL_MANAGEMENT_EVENTS"], r.state)
    ])
    error_message = "The state must be one of: ENABLED, DISABLED, ENABLED_WITH_ALL_CLOUDTRAIL_MANAGEMENT_EVENTS."
  }
}

variable "targets" {
  description = "A map of targets to attach to the rules. Key is rule_name/target_id."
  type = map(object({
    rule_name = string
    arn       = string
    role_arn  = optional(string)
    input     = optional(string)
    dead_letter_arn = optional(string)
  }))
  default = {}
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
