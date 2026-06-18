variable "name" {
  description = "Name of the knowledge base"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "aws_account_id" {
  description = "AWS account ID"
  type        = string
}

variable "embedding_model_arn" {
  description = "ARN of the embedding model"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:bedrock:[a-z0-9-]+::foundation-model/.*$", var.embedding_model_arn))
    error_message = "The embedding_model_arn must be a valid Bedrock foundation model ARN."
  }
}

variable "storage_type" {
  description = "Type of storage for the knowledge base"
  type        = string
  default     = "OPENSEARCH_SERVERLESS"

  validation {
    condition     = contains(["OPENSEARCH_SERVERLESS", "PINECONE", "REDIS_ENTERPRISE_CLOUD", "RDS"], var.storage_type)
    error_message = "Storage type must be one of OPENSEARCH_SERVERLESS, PINECONE, REDIS_ENTERPRISE_CLOUD, or RDS."
  }
}

variable "opensearch_serverless_configuration" {
  description = "Configuration for OpenSearch Serverless storage"
  type = object({
    collection_arn    = string
    vector_index_name = string
    vector_field      = string
    text_field        = string
    metadata_field    = string
  })
  default = null
}

variable "pinecone_configuration" {
  description = "Configuration for Pinecone storage"
  type = object({
    connection_string      = string
    credentials_secret_arn = string
    text_field             = string
    metadata_field         = string
  })
  default = null
}

variable "rds_configuration" {
  description = "Configuration for RDS Aurora storage"
  type = object({
    resource_arn           = string
    credentials_secret_arn = string
    database_name          = string
    table_name             = string
    primary_key_field      = string
    vector_field           = string
    text_field             = string
    metadata_field         = string
  })
  default = null
}

variable "redis_enterprise_cloud_configuration" {
  description = "Configuration for Redis Enterprise Cloud storage"
  type = object({
    endpoint               = string
    credentials_secret_arn = string
    vector_index_name      = string
    vector_field           = string
    text_field             = string
    metadata_field         = string
  })
  default = null
}

variable "managed_policy_arns" {
  description = "List of managed policy ARNs to attach to the KB role"
  type        = list(string)
  default     = []
}

variable "permissions_boundary_arn" {
  description = "ARN of the permissions boundary to attach to the KB role"
  type        = string
  default     = null
}

variable "tags" {
  description = "A map of tags to assign to the resources. Required keys: environment, owner, project, cost_center."
  type        = map(string)

  validation {
    condition     = alltrue([for k in ["environment", "owner", "project", "cost_center"] : contains(keys(var.tags), k)])
    error_message = "The tags map must contain the following keys: environment, owner, project, cost_center."
  }
}
