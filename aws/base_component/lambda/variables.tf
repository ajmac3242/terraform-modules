variable "function_name" {
  description = "The name of the Lambda function"
  type        = string
}

variable "description" {
  description = "The description of the Lambda function"
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

variable "memory_size" {
  description = "Amount of memory in MB your Lambda Function can use at runtime"
  type        = number
  default     = 128
}

variable "timeout" {
  description = "The amount of time your Lambda Function has to run in seconds"
  type        = number
  default     = 3
}

variable "filename" {
  description = "The path to the function's deployment package within the local filesystem"
  type        = string
  default     = null
}

variable "environment_variables" {
  description = "A map of environment variables to assign to the Lambda function"
  type        = map(string)
  default     = {}
}

variable "kms_key_arn" {
  description = "The ARN of the KMS key used to encrypt your function's environment variables. If null, a new key will be created."
  type        = string
  default     = null
}

variable "existing_role_arn" {
  description = "The ARN of an existing IAM role to use for the Lambda function. If null, a new role will be created."
  type        = string
  default     = null
}

variable "dead_letter_config_target_arn" {
  description = "The ARN of an SNS topic or SQS queue to notify when an invocation fails"
  type        = string
  default     = null
}

variable "aws_account_id" {
  description = "The AWS Account ID to support tests/mocking"
  type        = string
  default     = null
}

variable "vpc_config" {
  description = "Provide this to allow your function to access your VPC"
  type = object({
    subnet_ids         = list(string)
    security_group_ids = list(string)
  })
  default = null
}

variable "retention_in_days" {
  description = "Specifies the number of days you want to retain log events in the specified log group"
  type        = number
  default     = 30
}

variable "reserved_concurrent_executions" {
  description = "The amount of reserved concurrent executions for this lambda function. A value of -1 (default) removes any concurrency limitations from the function."
  type        = number
  default     = -1
}

variable "tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)

  validation {
    condition     = contains(keys(var.tags), "environment") && contains(keys(var.tags), "owner") && contains(keys(var.tags), "project") && contains(keys(var.tags), "cost_center")
    error_message = "The tags map must contain the following keys: environment, owner, project, cost_center."
  }
}
