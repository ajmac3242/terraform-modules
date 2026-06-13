variable "enable_default_standards" {
  description = "Whether to enable the security standards that Security Hub has designated as automatically enabled."
  type        = bool
  default     = true
}

variable "control_finding_generator" {
  description = "Updates whether the calling account has consolidated control findings turned on. (SECURITY_CONTROL, STANDARD_CONTROL)"
  type        = string
  default     = "SECURITY_CONTROL"

  validation {
    condition     = contains(["SECURITY_CONTROL", "STANDARD_CONTROL"], var.control_finding_generator)
    error_message = "The control_finding_generator must be either SECURITY_CONTROL or STANDARD_CONTROL."
  }
}

variable "auto_enable_controls" {
  description = "Whether to automatically enable new controls when they are added to standards that are enabled."
  type        = bool
  default     = true
}

variable "standards_subscriptions" {
  description = "A list of standards ARNs to subscribe to."
  type        = list(string)
  default     = []

  validation {
    condition     = alltrue([for arn in var.standards_subscriptions : can(regex("^arn:aws:securityhub:.*:.*:standards/.*$", arn))])
    error_message = "All standards_subscriptions must be valid Security Hub standards ARNs."
  }
}

variable "enable_finding_aggregator" {
  description = "Whether to enable cross-region finding aggregation."
  type        = bool
  default     = false
}

  validation {
    condition     = contains(keys(var.tags), "environment") && contains(keys(var.tags), "owner") && contains(keys(var.tags), "project") && contains(keys(var.tags), "cost_center")
    error_message = "The tags map must contain the following keys: environment, owner, project, cost_center."
  }
}
