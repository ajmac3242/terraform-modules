variable "name" {
  description = "The name of the state machine"
  type        = string
}

variable "definition" {
  description = "The Amazon States Language definition of the state machine"
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

variable "lambda_arns" {
  description = "A list of Lambda function ARNs that the state machine is allowed to invoke"
  type        = list(string)
  default     = []
}

variable "kms_key_arn" {
  description = "The ARN of the KMS key for encryption of logs"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:kms:[a-z0-9-]+:[0-9]{12}:key/[a-z0-9-]+$", var.kms_key_arn))
    error_message = "The kms_key_arn must be a valid AWS KMS key ARN."
  }
}

variable "log_group_retention_in_days" {
  description = "Specifies the number of days you want to retain log events in the log group"
  type        = number
  default     = 30
}

variable "permissions_boundary_arn" {
  description = "The ARN of the policy that is used to set the permissions boundary for the role"
  type        = string
  default     = null

  validation {
    condition     = var.permissions_boundary_arn == null || can(regex("^arn:aws:iam::[0-9]{12}:policy/.*$|^arn:aws:iam::aws:policy/.*$", var.permissions_boundary_arn))
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



variable "skip_sfn_creation" {
  description = "If true, skip creation of the state machine. Useful for offline tests where SFN validation fails."
  type        = bool
  default     = false
}
