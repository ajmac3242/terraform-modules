variable "zone_id" {
  description = "The ID of the hosted zone"
  type        = string
}

variable "records" {
  description = "A list of records to create"
  type = list(object({
    name    = string
    type    = string
    ttl     = optional(number)
    records = optional(list(string))
    alias = optional(object({
      name                   = string
      zone_id                = string
      evaluate_target_health = bool
    }))
  }))
}

variable "tags" {
  description = "A map of tags to assign to the resources. Note: Route 53 records do not support tags, but this variable is required for consistency across modules."
  type        = map(string)
  default     = {}

  validation {
    condition     = length(var.tags) == 0 ? true : (contains(keys(var.tags), "environment") && contains(keys(var.tags), "owner") && contains(keys(var.tags), "project") && contains(keys(var.tags), "cost_center"))
    error_message = "The tags map must contain the following keys: environment, owner, project, cost_center."
  }
}

