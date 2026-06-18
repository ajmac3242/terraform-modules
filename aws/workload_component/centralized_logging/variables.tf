variable "name_prefix" {
  description = "Prefix to use for all resources created by this module"
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)

  validation {
    condition     = contains(keys(var.tags), "environment") && contains(keys(var.tags), "owner") && contains(keys(var.tags), "project") && contains(keys(var.tags), "cost_center")
    error_message = "The tags map must contain the following keys: environment, owner, project, cost_center."
  }
}



variable "alb_account_id" {
  description = "The AWS account ID for the ELB service principal in the current region"
  type        = string
}

variable "vpc_flow_logs_service_principal" {
  description = "The service principal for VPC Flow Logs (usually delivery.logs.amazonaws.com)"
  type        = string
  default     = "delivery.logs.amazonaws.com"
}
