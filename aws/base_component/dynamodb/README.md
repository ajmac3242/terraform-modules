# aws/base_component/dynamodb

Opinionated DynamoDB table module. Enforces CMK encryption and point-in-time recovery.

## Features

- `aws_dynamodb_table` with configurable `hash_key`, `range_key`, and `attributes`
- `billing_mode` defaults to `PAY_PER_REQUEST`
- `server_side_encryption` using mandatory `kms_key_arn`
- `point_in_time_recovery` enabled by default
- Required tags enforced

## Usage

```hcl
module "dynamodb" {
  source = "./aws/base_component/dynamodb"

  table_name = "my-table"
  hash_key   = "id"
  attributes = [
    {
      name = "id"
      type = "S"
    }
  ]
  kms_key_arn = "arn:aws:kms:us-east-1:123456789012:key/..."

  tags = {
    environment = "prod"
    owner       = "platform-team"
    project     = "my-app"
    cost_center = "CC-1234"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `table_name` | The name of the DynamoDB table | `string` | n/a | yes |
| `hash_key` | The attribute to use as the hash (partition) key | `string` | n/a | yes |
| `range_key` | The attribute to use as the range (sort) key | `string` | `null` | no |
| `attributes` | List of nested attribute definitions. Only required for hash_key and range_key attributes. | `list(object)` | n/a | yes |
| `billing_mode` | Controls how you are charged for read and write throughput and how you manage capacity | `string` | `"PAY_PER_REQUEST"` | no |
| `kms_key_arn` | The ARN of the KMS key to use for server-side encryption | `string` | n/a | yes |
| `pitr_enabled` | Indicates whether point-in-time recovery is enabled | `bool` | `true` | no |
| `tags` | A map of tags to assign to the resources. Required keys: `environment`, `owner`, `project`, `cost_center`. | `map(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| `table_arn` | The ARN of the DynamoDB table |
| `table_name` | The name of the DynamoDB table |
| `table_id` | The ID of the DynamoDB table |
