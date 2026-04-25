variable "name" {
  description = "The name of the LB"
  type        = string
}

variable "internal" {
  description = "If true, the LB will be internal"
  type        = bool
  default     = false
}

variable "security_groups" {
  description = "A list of security group IDs to assign to the LB"
  type        = list(string)
}

variable "subnets" {
  description = "A list of subnet IDs to attach to the LB"
  type        = list(string)
}

variable "enable_deletion_protection" {
  description = "If true, deletion of the load balancer will be disabled via the AWS API"
  type        = bool
  default     = true
}

variable "access_logs_bucket" {
  description = "The S3 bucket name to store the logs in"
  type        = string
}

variable "access_logs_prefix" {
  description = "The S3 bucket prefix"
  type        = string
  default     = "alb"
}

variable "access_logs_enabled" {
  description = "Boolean to enable / disable access_logs"
  type        = bool
  default     = true
}

variable "enable_https_listener" {
  description = "If true, an HTTPS listener will be created"
  type        = bool
  default     = false
}

variable "certificate_arn" {
  description = "The ARN of the SSL certificate to use for the HTTPS listener"
  type        = string
  default     = null
}

variable "enable_http_redirect" {
  description = "If true, an HTTP listener will be created that redirects to HTTPS"
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

variable "aws_account_id" {
  description = "The AWS Account ID to support tests/mocking"
  type        = string
  default     = null
}
