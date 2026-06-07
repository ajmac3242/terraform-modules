variable "function_name" {
  description = "The name of the Lambda function"
  type        = string
}

variable "description" {
  description = "Description of the Lambda function"
  type        = string
  default     = "Lambda with Powertools"
}

variable "runtime" {
  description = "The runtime for the Lambda function"
  type        = string
  default     = "python3.11"
}

variable "handler" {
  description = "The function entrypoint in your code"
  type        = string
  default     = "index.handler"
}

variable "filename" {
  description = "The path to the function's deployment package within the local filesystem"
  type        = string
}

variable "service_name" {
  description = "The name of the service for Powertools"
  type        = string
}

variable "log_level" {
  description = "The log level for Powertools"
  type        = string
  default     = "INFO"
}

variable "powertools_layer_arn" {
  description = "The ARN of the Lambda Powertools layer"
  type        = string
}

variable "kms_key_arn" {
  description = "The ARN of the KMS key for encryption of environment variables and logs"
  type        = string
  default     = null

  validation {
    condition     = var.kms_key_arn == null || can(regex("^arn:aws:kms:[a-z0-9-]+:[0-9]{12}:key/[a-z0-9-]+$", var.kms_key_arn))
    error_message = "The kms_key_arn must be a valid AWS KMS key ARN."
  }}

variable "vpc_config" {
  description = "VPC configuration for the Lambda function"
  type = object({
    subnet_ids         = list(string)
    security_group_ids = list(string)
  })
  default = null
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
