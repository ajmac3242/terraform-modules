variable "name" {
  description = "The name of the VPC Lattice service network and service"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9-]{3,63}$", var.name))
    error_message = "The name must be between 3 and 63 characters and can only contain alphanumeric characters and hyphens."
  }
}

variable "auth_type" {
  description = "The auth type for the service network. Valid values are NONE and AWS_IAM."
  type        = string
  default     = "AWS_IAM"

  validation {
    condition     = contains(["NONE", "AWS_IAM"], var.auth_type)
    error_message = "The auth_type must be either NONE or AWS_IAM."
  }
}

variable "vpc_id" {
  description = "The VPC ID to associate with the service network"
  type        = string

  validation {
    condition     = can(regex("^vpc-[0-9a-f]+$", var.vpc_id))
    error_message = "The vpc_id must be a valid AWS VPC ID."
  }
}

variable "kms_key_arn" {
  description = "The ARN of the KMS CMK to use for encrypting access logs. Standardized naming per memory."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:kms:[a-z0-9-]+:[0-9]{12}:key/[a-z0-9-]+$", var.kms_key_arn))
    error_message = "The KMS key ARN must be a valid AWS KMS key ARN."
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
