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

  validation {
    condition     = can(regex("^arn:aws:kms:[a-z0-9-]+:[0-9]{12}:key/[a-z0-9-]+$", var.kms_key_arn))
    error_message = "The kms_key_arn must be a valid AWS KMS key ARN."
  }
}

variable "cors_configuration" {
  description = "CORS configuration for the HTTP API"
  type = object({
    allow_credentials = optional(bool)
    allow_headers     = optional(list(string))
    allow_methods     = optional(list(string))
    allow_origins     = optional(list(string))
    expose_headers    = optional(list(string))
    max_age           = optional(number)
  })
  default = null
}

variable "domain_name" {
  description = "Custom domain name for the API Gateway"
  type        = string
  default     = null
}

variable "certificate_arn" {
  description = "The ARN of the ACM certificate for the custom domain"
  type        = string
  default     = null

  validation {
    condition     = var.certificate_arn == null ? true : can(regex("^arn:aws:acm:[a-z0-9-]+:[0-9]{12}:certificate/.*$", var.certificate_arn))
    error_message = "The certificate_arn must be a valid AWS ACM certificate ARN."
  }
}

variable "jwt_issuer" {
  description = "The base URL of the IdP that issues JWTs"
  type        = string
  default     = null

  validation {
    condition     = var.jwt_issuer == null ? true : can(regex("^https://", var.jwt_issuer))
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

variable "permissions_boundary_arn" {
  description = "The ARN of the policy that is used to set the permissions boundary for the role"
  type        = string
  default     = null

  validation {
    condition     = var.permissions_boundary_arn == null ? true : can(regex("^arn:aws:iam::[0-9]{12}:policy/.*$|^arn:aws:iam::aws:policy/.*$", var.permissions_boundary_arn))
    error_message = "The permissions_boundary_arn must be a valid AWS IAM policy ARN."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resources. Must include environment, owner, project, and cost_center."
  type        = map(string)

  validation {
    condition     = alltrue([for k in ["environment", "owner", "project", "cost_center"] : contains(keys(var.tags), k)])
    error_message = "The tags map must contain the following keys: environment, owner, project, cost_center."
  }
}

variable "aws_account_id" {
  description = "The AWS Account ID to support tests/mocking"
  type        = string
  default     = null
}
