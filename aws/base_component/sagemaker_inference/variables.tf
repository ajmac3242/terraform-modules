variable "name" {
  description = "The name of the SageMaker inference resources"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9-]+$", var.name))
    error_message = "The name must contain only alphanumeric characters and hyphens."
  }
}

variable "execution_role_arn" {
  description = "The ARN of the IAM role for SageMaker execution. If null, a role will be created."
  type        = string
  default     = null
}

variable "container_image" {
  description = "The container image to use for inference"
  type        = string
}

variable "instance_type" {
  description = "The instance type to use for the inference endpoint"
  type        = string
  default     = "ml.t2.medium"
}

variable "kms_key_arn" {
  description = "The ARN of the KMS key for encryption. Format: ^arn:aws:kms:[a-z0-9-]+:[0-9]{12}:key/[a-z0-9-]+$"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:kms:[a-z0-9-]+:[0-9]{12}:key/[a-z0-9-]+$", var.kms_key_arn))
    error_message = "The KMS key ARN must be a valid AWS KMS key ARN."
  }
}

variable "vpc_config" {
  description = "VPC configuration for SageMaker resources"
  type = object({
    security_group_ids = list(string)
    subnets            = list(string)
  })
}

variable "tags" {
  description = "A map of tags to assign to the resources. Must include environment, owner, project, and cost_center."
  type        = map(string)

  validation {
    condition     = alltrue([for k in ["environment", "owner", "project", "cost_center"] : contains(keys(var.tags), k)])
    error_message = "The tags map must contain the following keys: environment, owner, project, cost_center."
  }
}
