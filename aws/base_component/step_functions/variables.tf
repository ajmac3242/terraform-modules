variable "name" {
  description = "The name of the state machine"
  type        = string
}

variable "definition" {
  description = "The Amazon States Language definition of the state machine"
  type        = string
}

variable "role_arn" {
  description = "The ARN of the IAM role to use for the state machine"
  type        = string
}

variable "type" {
  description = "Determines whether a Standard or Express state machine is created. Valid values are STANDARD and EXPRESS"
  type        = string
  default     = "STANDARD"

  validation {
    condition     = contains(["STANDARD", "EXPRESS"], var.type)
    error_message = "The type must be either STANDARD or EXPRESS."
  }
}

variable "kms_key_arn" {
  description = "The ARN of the KMS key for encryption"
  type        = string
}

variable "log_group_retention_in_days" {
  description = "Specifies the number of days you want to retain log events in the log group"
  type        = number
  default     = 30
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

variable "skip_sfn_creation" {
  description = "Toggle to skip state machine creation (useful for tests failing on SFN validation)"
  type        = bool
  default     = false
}
