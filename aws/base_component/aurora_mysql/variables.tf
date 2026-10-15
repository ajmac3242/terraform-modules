variable "cluster_identifier" {
  description = "The cluster identifier for the Aurora MySQL cluster"
  type        = string
}

variable "engine_version" {
  description = "The engine version for Aurora MySQL (must be 8.0.mysql_aurora.3.x release)"
  type        = string
  default     = "8.0.mysql_aurora.3.05.2"

  validation {
    condition     = can(regex("^8\\.0\\.mysql_aurora\\.3\\.", var.engine_version))
    error_message = "The engine_version must be a 8.0.mysql_aurora.3.x release."
  }
}

variable "db_cluster_parameter_group_family" {
  description = "The family of the DB cluster parameter group"
  type        = string
  default     = "aurora-mysql8.0"
}

variable "database_name" {
  description = "Name for the primary database created on cluster launch"
  type        = string
  default     = "main"
}

variable "master_username" {
  description = "Master username for the DB cluster"
  type        = string
}

variable "master_password" {
  description = "Master password for the DB cluster"
  type        = string
  sensitive   = true
}

variable "instance_class" {
  description = "The instance class for DB cluster instances (e.g. 'db.serverless' or 'db.r6g.xlarge')"
  type        = string
  default     = "db.serverless"
}

variable "instances_count" {
  description = "Number of DB instances to launch in the cluster"
  type        = number
  default     = 2
}

variable "vpc_id" {
  description = "VPC ID where the DB cluster will be deployed"
  type        = string
}

variable "vpc_cidr_block" {
  description = "CIDR block of the VPC allowed to connect to MySQL (port 3306)"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for the DB subnet group"
  type        = list(string)
}

variable "kms_key_arn" {
  description = "ARN of the KMS CMK for storage and log encryption"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:kms:[a-z0-9-]+:[0-9]{12}:key/[a-z0-9-]+$", var.kms_key_arn))
    error_message = "The kms_key_arn must be a valid AWS KMS key ARN."
  }
}

variable "cloudwatch_kms_key_arn" {
  description = "Optional ARN of the KMS CMK for CloudWatch logs encryption. Defaults to kms_key_arn if null."
  type        = string
  default     = null

  validation {
    condition     = var.cloudwatch_kms_key_arn == null ? true : can(regex("^arn:aws:kms:[a-z0-9-]+:[0-9]{12}:key/[a-z0-9-]+$", var.cloudwatch_kms_key_arn))
    error_message = "The cloudwatch_kms_key_arn must be a valid AWS KMS key ARN."
  }
}

variable "backup_retention_period" {
  description = "Number of days to retain automated backups (minimum 7 days)"
  type        = number
  default     = 7

  validation {
    condition     = var.backup_retention_period >= 7
    error_message = "The backup_retention_period must be at least 7 days."
  }
}

variable "storage_type" {
  description = "The storage type for the DB cluster. Defaults to 'aurora-iopt1' (I/O-Optimized)."
  type        = string
  default     = "aurora-iopt1"
}

variable "enable_serverlessv2" {
  description = "Whether to configure Aurora Serverless v2 scaling"
  type        = bool
  default     = true
}

variable "serverlessv2_scaling_configuration" {
  description = "Serverless v2 scaling configuration specifying min_capacity and max_capacity in ACUs"
  type = object({
    min_capacity = number
    max_capacity = number
  })
  default = {
    min_capacity = 0.5
    max_capacity = 16.0
  }
}

variable "enabled_cloudwatch_logs_exports" {
  description = "List of log types to export to CloudWatch Logs (audit, error, general, slowquery)"
  type        = list(string)
  default     = ["audit", "error", "general", "slowquery"]
}

variable "log_retention_in_days" {
  description = "Number of days to retain CloudWatch logs"
  type        = number
  default     = 30
}

variable "enable_kiro_mcp_integration" {
  description = "Whether to configure IAM roles and associations for Kiro Powers (MCP) integration"
  type        = bool
  default     = true
}

variable "kiro_mcp_principal_arns" {
  description = "List of IAM principal ARNs (e.g. AI-DLC execution roles) allowed to assume Kiro MCP roles"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "A map of tags to assign to all resources. Required keys: environment, owner, project, cost_center."
  type        = map(string)

  validation {
    condition     = contains(keys(var.tags), "environment") && contains(keys(var.tags), "owner") && contains(keys(var.tags), "project") && contains(keys(var.tags), "cost_center")
    error_message = "The tags map must contain the following keys: environment, owner, project, cost_center."
  }
}
