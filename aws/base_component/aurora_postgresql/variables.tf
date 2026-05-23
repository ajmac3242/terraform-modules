variable "cluster_identifier" {
  description = "The cluster identifier"
  type        = string
}

variable "engine_version" {
  description = "The engine version for Aurora PostgreSQL"
  type        = string
  default     = "16.1"
}

variable "instance_class" {
  description = "The instance class for Aurora cluster instances"
  type        = string
}

variable "instances_count" {
  description = "Number of Aurora instances"
  type        = number
  default     = 2
}

variable "vpc_id" {
  description = "VPC ID where the cluster will be deployed"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for the DB subnet group"
  type        = list(string)
}

variable "kms_key_arn" {
  description = "ARN of the KMS CMK for storage encryption"
  type        = string
}

variable "database_name" {
  description = "Name for the primary database"
  type        = string
  default     = "postgres"
}

variable "master_username" {
  description = "Username for the master DB user"
  type        = string
}

variable "master_password" {
  description = "Password for the master DB user"
  type        = string
  sensitive   = true
}

variable "s3_import_bucket_arn" {
  description = "Optional ARN of the S3 bucket to allow Aurora to import data from"
  type        = string
  default     = null
}

variable "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)

  validation {
    condition     = contains(keys(var.tags), "environment") && contains(keys(var.tags), "owner") && contains(keys(var.tags), "project") && contains(keys(var.tags), "cost_center")
    error_message = "The tags map must contain the following keys: environment, owner, project, cost_center."
  }
}
