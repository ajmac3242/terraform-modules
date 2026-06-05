variable "name" {
  description = "The name of the EventBridge rule and used as a prefix for other resources"
  type        = string
}

variable "description" {
  description = "The description of the EventBridge rule and Lambda function"
  type        = string
}

variable "event_bus_name" {
  description = "The name of the event bus to associate with the rule. Defaults to 'default'."
  type        = string
  default     = "default"
}

variable "event_pattern" {
  description = "The event pattern for the EventBridge rule"
  type        = string
  default     = null
}

variable "schedule_expression" {
  description = "The schedule expression for the EventBridge rule"
  type        = string
  default     = null
}

variable "lambda_function_name" {
  description = "The name of the Lambda function to create or use"
  type        = string
}

variable "lambda_handler" {
  description = "The Lambda function handler"
  type        = string
}

variable "lambda_runtime" {
  description = "The Lambda function runtime"
  type        = string
}

variable "lambda_source_path" {
  description = "The path to the Lambda function source code (zip file)"
  type        = string
}

variable "lambda_vpc_config" {
  description = "The VPC configuration for the Lambda function"
  type = object({
    subnet_ids         = list(string)
    security_group_ids = list(string)
  })
  default = null
}

variable "enable_dlq" {
  description = "Whether to enable a dead-letter queue for the EventBridge target"
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
