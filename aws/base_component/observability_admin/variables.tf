variable "rule_name" {
  description = "The name of the telemetry rule"
  type        = string
}

variable "telemetry_type" {
  description = "The type of telemetry to collect (e.g., Logs, Metrics, Traces)"
  type        = string

  validation {
    condition     = contains(["Logs", "Metrics", "Traces"], var.telemetry_type)
    error_message = "The telemetry_type must be one of: Logs, Metrics, Traces."
  }
}

variable "resource_type" {
  description = "The type of resource to apply the rule to (e.g., AWS::Lambda::Function)"
  type        = string
  default     = null
}

variable "is_organization_rule" {
  description = "Whether to create the rule at the organizational level"
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
