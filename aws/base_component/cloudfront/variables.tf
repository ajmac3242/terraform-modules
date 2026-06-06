variable "origin_domain_name" {
  description = "The domain name for the origin"
  type        = string
}

variable "origin_id" {
  description = "A unique identifier for the origin"
  type        = string
}

variable "origin_type" {
  description = "The type of origin (S3 or ALB)"
  type        = string
  default     = "S3"

  validation {
    condition     = contains(["S3", "ALB"], var.origin_type)
    error_message = "The origin_type must be either S3 or ALB."
  }
}

variable "waf_web_acl_id" {
  description = "The ID of the WAF Web ACL to associate with the distribution"
  type        = string
}

variable "log_bucket_domain_name" {
  description = "The domain name of the S3 bucket for access logs"
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


variable "aws_account_id" {
  description = "The AWS Account ID to support tests/mocking"
  type        = string
  default     = null
}
