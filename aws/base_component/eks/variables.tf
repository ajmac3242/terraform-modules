variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "subnet_ids" {
  description = "A list of subnet IDs where the EKS cluster and nodes will be placed"
  type        = list(string)
}

variable "kms_key_arn" {
  description = "The ARN of the KMS key for secret encryption"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:kms:[a-z0-9-]+:[0-9]{12}:key/[a-z0-9-]+$", var.kms_key_arn))
    error_message = "The KMS key ARN must be a valid AWS KMS key ARN."
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
