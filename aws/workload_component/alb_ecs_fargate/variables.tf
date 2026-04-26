variable "name" {
  description = "Name for the resources"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where resources will be created"
  type        = string
}

variable "private_subnet_ids" {
  description = "A list of private subnet IDs for the Fargate service"
  type        = list(string)
}

variable "public_subnet_ids" {
  description = "A list of public subnet IDs for the ALB (if creating new)"
  type        = list(string)
  default     = []
}

variable "container_image" {
  description = "The image used to start a container"
  type        = string
}

variable "container_port" {
  description = "The port number on the container"
  type        = number
  default     = 80
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
  description = "Number of instances of the task definition"
  type        = number
  default     = 1
}

variable "kms_key_arn" {
  description = "The ARN of the KMS key for encryption"
  type        = string
}

variable "alb_security_group_ids" {
  description = "A list of security group IDs for the ALB"
  type        = list(string)
  default     = []
}

variable "ecs_service_security_group_ids" {
  description = "A list of security group IDs for the ECS service"
  type        = list(string)
}

variable "use_existing_alb" {
  description = "If true, use the provided existing ALB and listener"
  type        = bool
  default     = false
}

variable "existing_alb_listener_arn" {
  description = "The ARN of the existing ALB listener (required if use_existing_alb is true)"
  type        = string
  default     = null
}

variable "enable_https" {
  description = "If true, enable HTTPS on the ALB"
  type        = bool
  default     = false
}

variable "certificate_arn" {
  description = "The ARN of the SSL certificate for HTTPS"
  type        = string
  default     = null
}

variable "access_logs_bucket" {
  description = "S3 bucket for ALB access logs"
  type        = string
  default     = null
}

variable "health_check_path" {
  description = "The destination for the health check request"
  type        = string
  default     = "/"
}

variable "permissions_boundary_arn" {
  description = "The ARN of the policy for permissions boundary"
  type        = string
  default     = null
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
