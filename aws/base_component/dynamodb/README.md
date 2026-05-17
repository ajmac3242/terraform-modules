# aws/base_component/dynamodb

## Purpose
Opinionated DynamoDB table module. Core NoSQL storage, enforcing CMK encryption and point-in-time recovery for data durability.

## Usage
```hcl
module "dynamodb" {
  source = "./aws/base_component/dynamodb"

  table_name  = "my-table"
  hash_key    = "id"
  kms_key_arn = module.kms.key_arn

  attributes = [
    {
      name = "id"
      type = "S"
    }
  ]

  tags = {
    environment = "prod"
    owner       = "platform-team"
    project     = "standardization"
    cost_center = "12345"
  }
}
```

## Security
- **Encryption**: Mandatory Server-Side Encryption using a Customer Managed Key (CMK).
- **Durability**: Point-in-time recovery (PITR) is enabled by default to protect against accidental deletes.
- **Network**: Accessible via VPC Gateway Endpoints for private data transfer.

## Variables
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `table_name` | Name of the DynamoDB table | `string` | n/a | yes |
| `hash_key` | The attribute to use as the hash (partition) key | `string` | n/a | yes |
| `range_key` | The attribute to use as the range (sort) key | `string` | `null` | no |
| `attributes` | List of nested attribute definitions | `list(map(string))` | n/a | yes |
| `kms_key_arn` | KMS key ARN for server-side encryption | `string` | n/a | yes |
| `billing_mode` | Controls how you are charged for read and write throughput | `string` | `"PAY_PER_REQUEST"` | no |
| `point_in_time_recovery_enabled` | Whether to enable point-in-time recovery | `bool` | `true` | no |
| `tags` | Standard tags for all resources | `map(string)` | n/a | yes |

## Outputs
| Name | Description |
|------|-------------|
| `table_arn` | The ARN of the DynamoDB table |
| `table_name` | The name of the DynamoDB table |
| `table_id` | The ID of the DynamoDB table |
| `tags` | A map of tags assigned to the resource |
