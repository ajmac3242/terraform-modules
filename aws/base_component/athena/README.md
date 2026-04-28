# aws/base_component/athena

## Purpose
Opinionated Athena module. Enables secure, serverless ad-hoc querying of S3 data. Standardizes workgroup settings, encryption of results, and data access patterns.

## Usage
```hcl
module "athena" {
  source = "./aws/base_component/athena"

  name            = "analytics-workgroup"
  output_location = "s3://${module.s3_results.bucket_id}/query-results/"
  kms_key_arn     = module.kms.key_arn

  tags = {
    environment = "prod"
    owner       = "platform-team"
    project     = "standardization"
    cost_center = "12345"
  }
}
```

## Security
- **Encryption**: Mandatory encryption for query results at rest using a Customer Managed Key (CMK). Configuration is enforced to prevent client-side overrides.
- **Cost Control**: Supports optional `bytes_scanned_cutoff_per_query` to prevent runaway costs.
- **Visibility**: CloudWatch metrics are enabled by default for all queries.

## Variables
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `name` | Name of the Athena workgroup | `string` | n/a | yes |
| `description` | Description of the Athena workgroup | `string` | `"Opinionated Athena workgroup"` | no |
| `output_location` | S3 bucket location where query results are stored | `string` | n/a | yes |
| `kms_key_arn` | ARN of the KMS key for encrypting query results | `string` | n/a | yes |
| `publish_cloudwatch_metrics_enabled` | Whether to publish CloudWatch metrics | `bool` | `true` | no |
| `bytes_scanned_cutoff_per_query` | Maximum bytes scanned per query | `number` | `null` | no |
| `tags` | Standard tags for all resources | `map(string)` | n/a | yes |

## Outputs
| Name | Description |
|------|-------------|
| `workgroup_arn` | The ARN of the Athena workgroup |
| `workgroup_id` | The ID of the Athena workgroup |
