variable "bucket_name" {
  description = "The name of the S3 bucket to create or use"
  type        = string
}

variable "lambda_function_name" {
  description = "The name of the Lambda function to create or use"
  type        = string
}

variable "lambda_description" {
  description = "The description of the Lambda function"
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

variable "events" {
  description = "A list of S3 events that will trigger the Lambda function"
  type        = list(string)
  default     = ["s3:ObjectCreated:*"]
}

variable "filter_prefix" {
  description = "The prefix filter for the S3 bucket notification"
  type        = string
  default     = null
}

variable "filter_suffix" {
  description = "The suffix filter for the S3 bucket notification"
  type        = string
  default     = null
}

variable "log_bucket_id" {
  description = "The ID of the S3 bucket to store access logs"
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
