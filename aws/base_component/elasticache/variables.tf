variable "cluster_id" {
  description = "Identifier for the ElastiCache cluster"
  type        = string
}

variable "engine" {
  description = "The name of the cache engine to be used for this cache cluster"
  type        = string
  default     = "redis"

  validation {
    condition     = contains(["redis", "valkey"], var.engine)
    error_message = "The engine must be either 'redis' or 'valkey'."
  }
}

variable "engine_version" {
  description = "The version number of the cache engine to be used"
  type        = string
  default     = "7.0"

  validation {
    condition     = can(regex("^[0-9.]+$", var.engine_version))
    error_message = "The engine_version must be a valid version number string."
  }
}

variable "node_type" {
  description = "The instance class used for the cache nodes"
  type        = string
  default     = "cache.t3.micro"
}

variable "num_cache_nodes" {
  description = "The initial number of cache nodes that the cache cluster will have"
  type        = number
  default     = 1
}

variable "subnet_ids" {
  description = "A list of VPC subnet IDs"
  type        = list(string)
}

variable "security_group_ids" {
  description = "List of security group IDs to associate with this cache cluster"
  type        = list(string)
}

variable "kms_key_arn" {
  description = "The ARN of the KMS key for encryption at rest"
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

variable "aws_account_id" {
  description = "The AWS Account ID to support tests/mocking"
  type        = string
  default     = null
}
