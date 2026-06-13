variable "role_name" {
  description = "The name of the IAM role. (1–64 chars, alphanumeric + +=,.@_/-)"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9+=,.@_/-]{1,64}$", var.role_name))
    error_message = "The role_name must be between 1 and 64 characters and can only contain alphanumeric characters and +=,.@_/-."
  }
}

variable "description" {
  description = "The description of the IAM role"
  type        = string
}

variable "assume_role_policy" {
  description = "The assume role policy for the IAM role (JSON string)"
  type        = string
}

variable "managed_policy_arns" {
  description = "A list of managed policy ARNs to attach to the IAM role"
  type        = list(string)
  default     = []

  validation {
    condition     = alltrue([for arn in var.managed_policy_arns : can(regex("^arn:aws:iam::[0-9]{12}:policy/.*$|^arn:aws:iam::aws:policy/.*$", arn))])
    error_message = "All managed_policy_arns must be valid AWS IAM policy ARNs."
  }
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
