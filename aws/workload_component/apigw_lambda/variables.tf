variable "name" {
  description = "The name of the API Gateway and Lambda function"
  type        = string
}

variable "description" {
  description = "The description of the API Gateway and Lambda function"
  type        = string
}

variable "runtime" {
  description = "The runtime for the Lambda function"
  type        = string
}

variable "handler" {
  description = "The function entrypoint in your code"
  type        = string
}

variable "filename" {
  description = "The path to the function's deployment package within the local filesystem"
  type        = string
  default     = null
}

variable "route_key" {
  description = "The route key for the API Gateway (e.g., 'POST /items')"
  type        = string
  default     = "$default"
}

variable "kms_key_arn" {
  description = "The ARN of the KMS key for encryption"
  type        = string
}

variable "jwt_issuer" {
  description = "The base URL of the IdP that issues JWTs"
  type        = string

  validation {
    condition     = can(regex("^https://", var.jwt_issuer))
    error_message = "The jwt_issuer must be an HTTPS URL."
  }
}

variable "jwt_audience" {
  description = "The list of audiences that are allowed to access the API"
  type        = list(string)
  default     = []
}

variable "waf_web_acl_arn" {
  description = "The ARN of the WAF Web ACL to associate with the API Gateway stage"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:wafv2:.*:.*:regional/webacl/.*", var.waf_web_acl_arn))
    error_message = "The waf_web_acl_arn must be a valid WAFv2 regional Web ACL ARN."
  }
}

variable "disable_authorizer" {
  description = "Whether to disable the JWT authorizer for the API Gateway route"
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
