variable "cluster_identifier" {
  description = "The cluster identifier"
  type        = string
}

variable "engine_version" {
  description = "The engine version for Aurora PostgreSQL"
  type        = string
  default     = "16.1"
}

variable "db_cluster_parameter_group_family" {
  description = "The family of the DB cluster parameter group"
  type        = string
  default     = "aurora-postgresql16"
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

  validation {
    condition     = can(regex("^arn:aws:kms:[a-z0-9-]+:[0-9]{12}:key/[a-z0-9-]+$", var.kms_key_arn))
    error_message = "The KMS key ARN must be a valid AWS KMS key ARN."
  }
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

variable "lambda_invocation_arns" {
  description = "Optional list of Lambda function ARNs that Aurora is allowed to invoke"
  type        = list(string)
  default     = []
}

variable "backup_retention_period" {
  description = "The days to retain backups for"
  type        = number
  default     = 7
}

variable "storage_type" {
  description = "The storage type for the DB cluster. Use 'aurora-iopt1' for I/O-Optimized."
  type        = string
  default     = "aurora-iopt1"
}

variable "allowed_extensions" {
  description = "Comma-separated list of allowed extensions for the DB cluster."
  type        = string
  default     = "pgvector,aws_lambda,aws_s3"
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
