variable "name" {
  description = "Name for the ECS cluster and service"
  type        = string
}

variable "private_subnet_ids" {
  description = "A list of private subnet IDs for the Fargate service"
  type        = list(string)
}

variable "security_group_ids" {
  description = "A list of security group IDs to assign to the ECS service"
  type        = list(string)
  default     = []
}

variable "container_image" {
  description = "The image used to start a container"
  type        = string
}

variable "container_port" {
  description = "The port number on the container that is bound to the user-specified or automatically assigned host port"
  type        = number
  default     = 80
}

variable "platform_version" {
  description = "The platform version on which to run your service"
  type        = string
  default     = "LATEST"
}

variable "cpu" {
  description = "Number of cpu units used by the task"
  type        = number
  default     = 256
}

variable "memory" {
  description = "Amount (in MiB) of memory used by the task"
  type        = number
  default     = 512
}

variable "desired_count" {
  description = "Number of instances of the task definition to place and keep running"
  type        = number
  default     = 1
}

variable "load_balancer_config" {
  description = "Optional load balancer configuration for the ECS service"
  type = object({
    target_group_arn = string
    container_name   = string
    container_port   = number
  })
  default = null
}

variable "kms_key_arn" {
  description = "The ARN of the KMS key for encryption of logs"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:kms:[a-z0-9-]+:[0-9]{12}:key/[a-z0-9-]+$", var.kms_key_arn))
    error_message = "The KMS key ARN must be a valid AWS KMS key ARN."
  }
}

variable "permissions_boundary_arn" {
  description = "The ARN of the policy that is used to set the permissions boundary for the roles"
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
