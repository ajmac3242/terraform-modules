variable "name" {
  description = "The name of the ASG and launch template"
  type        = string
}

variable "image_id" {
  description = "The AMI ID to use for the instances"
  type        = string
}

variable "instance_type" {
  description = "The instance type to use"
  type        = string
  default     = "t3.micro"
}

variable "min_size" {
  description = "The minimum size of the ASG"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "The maximum size of the ASG"
  type        = number
  default     = 3
}

variable "desired_capacity" {
  description = "The desired capacity of the ASG"
  type        = number
  default     = 1
}

variable "vpc_zone_identifier" {
  description = "A list of subnet IDs to launch resources in"
  type        = list(string)
}

variable "kms_key_arn" {
  description = "The ARN of the KMS key for EBS encryption"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:kms:[a-z0-9-]+:[0-9]{12}:key/[a-z0-9-]+$", var.kms_key_arn))
    error_message = "The kms_key_arn must be a valid KMS key ARN."
  }
}

variable "security_group_ids" {
  description = "A list of security group IDs to associate with the instances"
  type        = list(string)
  default     = []
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
