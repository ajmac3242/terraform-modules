variable "name" {
  description = "The name of the API Gateway"
  type        = string
}

variable "kms_key_arn" {
  description = "The ARN of the KMS key for log group encryption"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:kms:[a-z0-9-]+:[0-9]{12}:key/.*$", var.kms_key_arn))
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

variable "tags" {
  description = "A map of tags to assign to the resources. Must include environment, owner, project, and cost_center."
  type        = map(string)

  validation {
    condition     = alltrue([for k in ["environment", "owner", "project", "cost_center"] : contains(keys(var.tags), k)])
    error_message = "The tags map must contain the following keys: environment, owner, project, cost_center."
  }
}
