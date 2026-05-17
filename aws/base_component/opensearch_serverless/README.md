# OpenSearch Serverless (Vector Search)

## Purpose
This module provides an opinionated OpenSearch Serverless collection configured for **VECTORSEARCH**. It enforces security best practices including mandatory Customer Managed Key (CMK) encryption at rest, private-only network access via VPC endpoints, and least-privilege data access policies. This is a foundational component for Retrieval-Augmented Generation (RAG) and other AI/ML workloads on AWS.

## Usage
```hcl
module "opensearch_vector_store" {
  source = "./aws/base_component/opensearch_serverless"

  name        = "my-vector-store"
  kms_key_arn = "arn:aws:kms:us-east-1:123456789012:key/your-key-id"

  vpc_endpoint_ids = [
    "vpce-1234567890abcdef0"
  ]

  data_access_principals = [
    "arn:aws:iam::123456789012:role/bedrock-kb-role"
  ]

  tags = {
    environment = "prod"
    owner       = "platform-team"
    project     = "ai-foundations"
    cost_center = "12345"
  }
}
```

## Security
- **Encryption**: Enforces encryption at rest using a Customer Managed Key (CMK) via an encryption security policy.
- **Network**: Disables public access by default (`AllowFromPublic = false`) and restricts access to specific VPC interface endpoints.
- **Data Access**: Implements a data access policy that explicitly grants permissions only to provided IAM principals for collection and index operations.
- **Least Privilege**: Managed policies are used for all configuration to ensure consistent and auditable access control.

## Variables
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | The name of the OpenSearch Serverless collection | `string` | n/a | yes |
| kms_key_arn | The ARN of the KMS key for encryption at rest | `string` | n/a | yes |
| vpc_endpoint_ids | A list of VPC Endpoint IDs allowed to access the collection | `list(string)` | `[]` | no |
| data_access_principals | A list of IAM principal ARNs allowed to access the data in the collection | `list(string)` | n/a | yes |
| tags | Standard tags for all resources (environment, owner, project, cost_center) | `map(string)` | n/a | yes |

## Outputs
| Name | Description |
|------|-------------|
| collection_id | The unique identifier of the OpenSearch Serverless collection |
| collection_arn | The Amazon Resource Name (ARN) of the OpenSearch Serverless collection |
| collection_endpoint | The endpoint of the OpenSearch Serverless collection |
| `tags` | A map of tags assigned to the resource |
