variable "user_pool_name" {
  description = "Name of the Cognito User Pool"
  type        = string
}


variable "client_name" {
  description = "Name of the Cognito User Pool Client"
  type        = string
}

variable "advanced_security_mode" {
  description = "Advanced security mode. Must be one of: AUDIT, ENFORCED"
  type        = string
  default     = "ENFORCED"
  validation {
    condition     = contains(["AUDIT", "ENFORCED"], var.advanced_security_mode)
    error_message = "advanced_security_mode must be one of: AUDIT, ENFORCED."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resources. Required keys: environment, owner, project, cost_center."
  type        = map(string)
  validation {
    condition     = alltrue([for k in ["environment", "owner", "project", "cost_center"] : contains(keys(var.tags), k)])
    error_message = "The tags map must contain environment, owner, project, and cost_center keys."
  }
}
