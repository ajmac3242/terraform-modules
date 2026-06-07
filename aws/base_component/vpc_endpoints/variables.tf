variable "vpc_id" {
  description = "The ID of the VPC where endpoints will be created"
  type        = string
}

variable "region" {
  description = "The AWS region"
  type        = string
}

variable "subnet_ids" {
  description = "A list of subnet IDs for interface endpoints"
  type        = list(string)
  default     = []
}

variable "route_table_ids" {
  description = "A list of route table IDs for gateway endpoints"
  type        = list(string)
  default     = []
}

variable "security_group_ids" {
  description = "A list of security group IDs for interface endpoints"
  type        = list(string)
  default     = []
}

variable "endpoints" {
  description = "A map of endpoint configurations"
  type = map(object({
    service             = string
    service_type        = string # Interface or Gateway
    private_dns_enabled = optional(bool, true)
  }))
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
