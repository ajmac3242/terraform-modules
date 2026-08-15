variable "policy_name" {
  description = "The name of the Resilience Hub resiliency policy."
  type        = string
}

variable "tier" {
  description = "The tier for the resiliency policy, ranging from highest severity (MissionCritical) to lowest (NonCritical). Allowed values: MissionCritical, Critical, Important, CoreServices, NonCritical."
  type        = string

  validation {
    condition     = contains(["MissionCritical", "Critical", "Important", "CoreServices", "NonCritical"], var.tier)
    error_message = "The tier must be one of: MissionCritical, Critical, Important, CoreServices, NonCritical."
  }
}

variable "description" {
  description = "Description of the resiliency policy."
  type        = string
  default     = null
}

variable "data_location_constraint" {
  description = "Specifies a high-level geographical location constraint for where resilience policy data can be stored."
  type        = string
  default     = null
}

variable "policy_az" {
  description = "Target RTO and RPO for potential availability zone disruptions."
  type = object({
    rpo = string
    rto = string
  })
}

variable "policy_hardware" {
  description = "Target RTO and RPO for potential infrastructure/hardware disruptions."
  type = object({
    rpo = string
    rto = string
  })
}

variable "policy_software" {
  description = "Target RTO and RPO for potential application/software disruptions."
  type = object({
    rpo = string
    rto = string
  })
}

variable "policy_region" {
  description = "Target RTO and RPO for potential region disruptions."
  type = object({
    rpo = string
    rto = string
  })
  default = null
}

variable "tags" {
  description = "A map of tags to assign to the resource. Mandatory keys: environment, owner, project, cost_center."
  type        = map(string)

  validation {
    condition     = contains(keys(var.tags), "environment") && contains(keys(var.tags), "owner") && contains(keys(var.tags), "project") && contains(keys(var.tags), "cost_center")
    error_message = "The tags map must contain all required keys: environment, owner, project, cost_center."
  }
}
