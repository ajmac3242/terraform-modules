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

variable "selection_criteria" {
  description = "Selection criteria for telemetry data filtering"
  type        = string
  default     = null
}

variable "telemetry_source_types" {
  description = "List of telemetry source types (e.g., VPC_FLOW_LOGS, EKS_AUDIT_LOGS)"
  type        = list(string)
  default     = null
}

variable "scope" {
  description = "The scope of the telemetry rule"
  type        = string
  default     = null
}

variable "all_regions" {
  description = "Whether to apply the rule across all regions"
  type        = bool
  default     = null
}

variable "regions" {
  description = "List of regions to apply the rule to"
  type        = list(string)
  default     = null
}

variable "allow_field_updates" {
  description = "Whether to allow field updates for the rule"
  type        = bool
  default     = null
}

variable "destination_configurations" {
  description = "List of destination configurations for telemetry data delivery (e.g. CloudTrail, ELB, Log Delivery, MSK, VPC Flow Logs, WAF)."
  type = list(object({
    destination_type    = optional(string)
    destination_pattern = optional(string)
    retention_in_days   = optional(number)
    cloudtrail_parameters = optional(object({
      advanced_event_selectors = optional(list(object({
        name = optional(string)
        field_selectors = optional(list(object({
          field           = string
          equals          = optional(list(string))
          not_equals      = optional(list(string))
          starts_with     = optional(list(string))
          not_starts_with = optional(list(string))
          ends_with       = optional(list(string))
          not_ends_with   = optional(list(string))
        })))
      })))
    }))
    elb_load_balancer_logging_parameters = optional(object({
      field_delimiter = optional(string)
      output_format   = optional(string)
    }))
    log_delivery_parameters = optional(object({
      log_types = optional(list(string))
    }))
    msk_monitoring_parameters = optional(object({
      enhanced_monitoring = optional(string)
    }))
    vpc_flow_log_parameters = optional(object({
      log_format               = optional(string)
      max_aggregation_interval = optional(number)
      traffic_type             = optional(string)
    }))
    waf_logging_parameters = optional(object({
      log_type = optional(string)
      logging_filter = optional(object({
        default_behavior = optional(string)
        filters = optional(list(object({
          behavior    = optional(string)
          requirement = optional(string)
          conditions = optional(list(object({
            action_condition = optional(object({
              action = string
            }))
            label_name_condition = optional(object({
              label_name = optional(string)
            }))
          })))
        })))
      }))
      redacted_fields = optional(object({
        method       = optional(string)
        query_string = optional(string)
        uri_path     = optional(string)
        single_header = optional(object({
          name = string
        }))
      }))
    }))
  }))
  default = []
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
