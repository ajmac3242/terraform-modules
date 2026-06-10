data "aws_caller_identity" "current" {}

# IAM Role for Bedrock Knowledge Base
module "iam_role" {
  source = "../iam"

  role_name   = "${var.name}-kb-role"
  description = "IAM role for Bedrock Knowledge Base ${var.name}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "bedrock.amazonaws.com"
        }
        Condition = {
          StringEquals = {
            "aws:SourceAccount" = data.aws_caller_identity.current.account_id
          }
          ArnLike = {
            "aws:SourceArn" = "arn:aws:bedrock:${var.region}:${data.aws_caller_identity.current.account_id}:knowledge-base/*"
          }
        }
      }
    ]
  })

  managed_policy_arns      = var.managed_policy_arns
  permissions_boundary_arn = var.permissions_boundary_arn

  tags = var.tags
}

# Bedrock Knowledge Base resource
resource "aws_bedrockagent_knowledge_base" "this" {
  name     = var.name
  role_arn = module.iam_role.role_arn

  knowledge_base_configuration {
    type = "VECTOR"
    vector_knowledge_base_configuration {
      embedding_model_arn = var.embedding_model_arn
    }
  }

  storage_configuration {
    type = var.storage_type

    dynamic "opensearch_serverless_configuration" {
      for_each = (var.storage_type == "OPENSEARCH_SERVERLESS" && var.opensearch_serverless_configuration != null) ? [var.opensearch_serverless_configuration] : []
      content {
        collection_arn    = opensearch_serverless_configuration.value.collection_arn
        vector_index_name = opensearch_serverless_configuration.value.vector_index_name
        field_mapping {
          vector_field   = opensearch_serverless_configuration.value.vector_field
          text_field     = opensearch_serverless_configuration.value.text_field
          metadata_field = opensearch_serverless_configuration.value.metadata_field
        }
      }
    }

    dynamic "pinecone_configuration" {
      for_each = (var.storage_type == "PINECONE" && var.pinecone_configuration != null) ? [var.pinecone_configuration] : []
      content {
        connection_string      = pinecone_configuration.value.connection_string
        credentials_secret_arn = pinecone_configuration.value.credentials_secret_arn
        field_mapping {
          text_field     = pinecone_configuration.value.text_field
          metadata_field = pinecone_configuration.value.metadata_field
        }
      }
    }

    dynamic "rds_configuration" {
      for_each = (var.storage_type == "RDS" && var.rds_configuration != null) ? [var.rds_configuration] : []
      content {
        resource_arn           = rds_configuration.value.resource_arn
        credentials_secret_arn = rds_configuration.value.credentials_secret_arn
        database_name          = rds_configuration.value.database_name
        table_name             = rds_configuration.value.table_name
        field_mapping {
          primary_key_field = rds_configuration.value.primary_key_field
          vector_field      = rds_configuration.value.vector_field
          text_field        = rds_configuration.value.text_field
          metadata_field    = rds_configuration.value.metadata_field
        }
      }
    }

    dynamic "redis_enterprise_cloud_configuration" {
      for_each = (var.storage_type == "REDIS_ENTERPRISE_CLOUD" && var.redis_enterprise_cloud_configuration != null) ? [var.redis_enterprise_cloud_configuration] : []
      content {
        endpoint               = redis_enterprise_cloud_configuration.value.endpoint
        credentials_secret_arn = redis_enterprise_cloud_configuration.value.credentials_secret_arn
        vector_index_name      = redis_enterprise_cloud_configuration.value.vector_index_name
        field_mapping {
          vector_field   = redis_enterprise_cloud_configuration.value.vector_field
          text_field     = redis_enterprise_cloud_configuration.value.text_field
          metadata_field = redis_enterprise_cloud_configuration.value.metadata_field
        }
      }
    }
  }

  tags = var.tags
}
