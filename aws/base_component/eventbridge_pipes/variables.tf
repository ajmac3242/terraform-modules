variable "name" {
  description = "The name of the EventBridge Pipe"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9._-]{1,54}$", var.name))
    error_message = "The pipe name must be between 1 and 54 characters (to allow for IAM role suffix) and can only contain alphanumeric characters, dots, underscores, and hyphens."
  }
}

variable "description" {
  description = "Description of the pipe"
  type        = string
  default     = null
}

variable "source_arn" {
  description = "The ARN of the source resource (e.g., SQS, DynamoDB Stream, Kinesis Stream)"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:[a-z0-9-]+:[a-z0-9-]*:[0-9]{12}:.*$", var.source_arn))
    error_message = "The source_arn must be a valid AWS ARN."
  }
}

variable "target_arn" {
  description = "The ARN of the target resource (e.g., Lambda, Step Functions, EventBridge)"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:[a-z0-9-]+:[a-z0-9-]*:[0-9]{12}:.*$", var.target_arn))
    error_message = "The target_arn must be a valid AWS ARN."
  }
}

variable "enrichment_arn" {
  description = "The ARN of the enrichment resource (e.g., Lambda, Step Functions)"
  type        = string
  default     = null

  validation {
    condition     = var.enrichment_arn == null ? true : can(regex("^arn:aws:[a-z0-9-]+:[a-z0-9-]*:[0-9]{12}:.*$", var.enrichment_arn))
    error_message = "The enrichment_arn must be a valid AWS ARN."
  }
}

variable "source_parameters" {
  description = "Parameters for the source"
  type        = any
  default     = {}
}

variable "target_parameters" {
  description = "Parameters for the target"
  type        = any
  default     = {}
}

variable "enrichment_parameters" {
  description = "Parameters for the enrichment"
  type        = any
  default     = {}
}

variable "tags" {
  description = "A map of tags to assign to the pipe"
  type        = map(string)

  validation {
    condition     = contains(keys(var.tags), "environment") && contains(keys(var.tags), "owner") && contains(keys(var.tags), "project") && contains(keys(var.tags), "cost_center")
    error_message = "The tags map must contain the following keys: environment, owner, project, cost_center."
  }
}

variable "desired_state" {
  description = "The desired state of the pipe (RUNNING, STOPPED)"
  type        = string
  default     = "RUNNING"

  validation {
    condition     = contains(["RUNNING", "STOPPED"], var.desired_state)
    error_message = "The desired_state must be either RUNNING or STOPPED."
  }
}

variable "custom_policy_arns" {
  description = "A list of additional managed policy ARNs to attach to the pipe IAM role"
  type        = list(string)
  default     = []

  validation {
    condition     = alltrue([for arn in var.custom_policy_arns : can(regex("^arn:aws:iam::[0-9]{12}:policy/.*$|^arn:aws:iam::aws:policy/.*$", arn))])
    error_message = "All custom_policy_arns must be valid AWS IAM policy ARNs."
  }
}
