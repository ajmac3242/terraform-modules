variable "domain_name" {
  description = "The primary domain name for the website (e.g. example.com)"
  type        = string
}

variable "alternate_domains" {
  description = "List of alternate domain names (CNAMEs) for the website"
  type        = list(string)
  default     = []
}

variable "route53_zone_id" {
  description = "The Route 53 Hosted Zone ID where the records will be created"
  type        = string
}

variable "waf_web_acl_arn" {
  description = "The ARN of the WAFv2 Web ACL to associate with the CloudFront distribution. Must be in us-east-1."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:wafv2:us-east-1:.*:global/webacl/.*", var.waf_web_acl_arn))
    error_message = "The waf_web_acl_arn must be a global WAFv2 ARN in us-east-1 for CloudFront."
  }
}

variable "log_bucket_id" {
  description = "The ID of the S3 bucket to store access logs"
  type        = string
}

variable "aws_account_id" {
  description = "The AWS Account ID to support tests/mocking"
  type        = string
  default     = null
}

variable "tags" {
  description = "Standard tags for all resources"
  type        = map(string)

  validation {
    condition     = contains(keys(var.tags), "environment") && contains(keys(var.tags), "owner") && contains(keys(var.tags), "project") && contains(keys(var.tags), "cost_center")
    error_message = "The tags map must include environment, owner, project, and cost_center."
  }
}
