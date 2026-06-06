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

variable "layers" {
  description = "List of Lambda Layer Version ARNs (maximum of 5) to attach to your Lambda Function"
  type        = list(string)
  default     = []
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

  validation {
    condition     = var.kms_key_arn == null || can(regex("^arn:aws:kms:[a-z0-9-]+:[0-9]{12}:key/[a-z0-9-]+$", var.kms_key_arn))
    error_message = "The kms_key_arn must be a valid AWS KMS key ARN (arn:aws:kms:region:account:key/key-id)."
  }
}

variable "existing_role_arn" {
  description = "The ARN of an existing IAM role to use for the Lambda function. If null, a new role will be created."
  type        = string
  default     = null
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

variable "dead_letter_config_target_arn" {
  description = "The ARN of an SNS topic or SQS queue to notify when an invocation fails"
  type        = string
  default     = null

  validation {
    condition     = var.dead_letter_config_target_arn == null || can(regex("^arn:aws:(sns|sqs):[a-z0-9-]+:[0-9]{12}:.*$", var.dead_letter_config_target_arn))
    error_message = "The dead_letter_config_target_arn must be a valid AWS SNS topic or SQS queue ARN."
  }
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

variable "file_system_config" {
  description = "Connection settings for an EFS or S3 file system. Supports mounting a single S3 Files access point or EFS access point."
  type = list(object({
    arn              = string
    local_mount_path = string
  }))
  default = []

  validation {
    condition     = length(var.file_system_config) <= 1
    error_message = "Lambda function supports only one file_system_config block."
  }

  validation {
    condition     = alltrue([for f in var.file_system_config : can(regex("^arn:aws:(elasticfilesystem|s3files):[a-z0-9-]*:[0-9]{12}:.*$", f.arn))])
    error_message = "The file_system_config arn must be a valid AWS EFS Access Point ARN or S3 Files Access Point ARN."
  }

  validation {
    condition     = alltrue([for f in var.file_system_config : can(regex("^/mnt/.*$", f.local_mount_path))])
    error_message = "The local_mount_path must start with /mnt/."
  }
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
