# Bedrock Knowledge Base

## Purpose
This module provisions an opinionated Amazon Bedrock Knowledge Base. It standardizes the creation of the knowledge base, its associated IAM role, and its connection to a vector store (like OpenSearch Serverless or Pinecone), ensuring security best practices such as least-privilege IAM and mandatory tagging.

## Usage
```hcl
module "knowledge_base" {
  source = "./aws/base_component/bedrock_knowledge_base"

  name                = "my-knowledge-base"
  aws_account_id      = "123456789012"
  embedding_model_arn = "arn:aws:bedrock:us-east-1::foundation-model/amazon.titan-embed-text-v1"

  storage_type = "OPENSEARCH_SERVERLESS"
  opensearch_serverless_configuration = {
    collection_arn    = "arn:aws:aoss:us-east-1:123456789012:collection/my-collection"
    vector_index_name = "bedrock-knowledge-base-default-index"
    vector_field      = "bedrock-knowledge-base-default-vector"
    text_field        = "AMAZON_BEDROCK_TEXT_CHUNK"
    metadata_field    = "AMAZON_BEDROCK_METADATA"
  }

  tags = {
    environment = "prod"
    owner       = "ai-team"
    project     = "customer-support-bot"
    cost_center = "ai-research"
  }
}
```

## Security
- **Least-Privilege IAM**: The module creates a dedicated IAM role for the knowledge base with a strict trust policy and SourceAccount/SourceArn conditions.
- **CMK Encryption**: The security of the Knowledge Base is anchored by the encryption of the underlying storage (e.g., OpenSearch Serverless, RDS Aurora, or Pinecone) and the data sources (e.g., S3). Users must ensure that these components are configured with Customer Managed Keys (CMK) as per organizational standards.
- **Mandatory Tagging**: All resources are tagged with organizational defaults for tracking and cost allocation.

## Variables
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | Name of the knowledge base | `string` | n/a | yes |
| region | AWS region | `string` | `"us-east-1"` | no |
| aws_account_id | AWS account ID | `string` | n/a | yes |
| embedding_model_arn | ARN of the embedding model | `string` | n/a | yes |
| storage_type | Type of storage for the knowledge base | `string` | `"OPENSEARCH_SERVERLESS"` | no |
| opensearch_serverless_configuration | Configuration for OpenSearch Serverless storage | `object` | `null` | no |
| pinecone_configuration | Configuration for Pinecone storage | `object` | `null` | no |
| rds_configuration | Configuration for RDS Aurora storage | `object` | `null` | no |
| redis_enterprise_cloud_configuration | Configuration for Redis Enterprise Cloud storage | `object` | `null` | no |
| managed_policy_arns | List of managed policy ARNs to attach to the KB role | `list(string)` | `[]` | no |
| permissions_boundary_arn | ARN of the permissions boundary to attach to the KB role | `string` | `null` | no |
| tags | A map of tags to assign to the resources | `map(string)` | n/a | yes |

## Outputs
| Name | Description |
|------|-------------|
| knowledge_base_id | The ID of the knowledge base |
| knowledge_base_arn | The ARN of the knowledge base |
| role_arn | The ARN of the IAM role used by the knowledge base |
| role_name | The name of the IAM role used by the knowledge base |
