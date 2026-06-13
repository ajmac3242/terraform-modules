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

<!-- BEGIN_TF_DOCS -->


## Usage

```hcl
# See README.md for usage example
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | The ARN of the KMS key for encrypting query results | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of the Athena workgroup | `string` | n/a | yes |
| <a name="input_output_location"></a> [output\_location](#input\_output\_location) | The S3 bucket location where query results are stored (e.g. s3://bucket-name/prefix/) | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Standard tags for all resources | `map(string)` | n/a | yes |
| <a name="input_bytes_scanned_cutoff_per_query"></a> [bytes\_scanned\_cutoff\_per\_query](#input\_bytes\_scanned\_cutoff\_per\_query) | The maximum amount of data scanned per query in bytes | `number` | `null` | no |
| <a name="input_description"></a> [description](#input\_description) | Description of the Athena workgroup | `string` | `"Opinionated Athena workgroup"` | no |
| <a name="input_publish_cloudwatch_metrics_enabled"></a> [publish\_cloudwatch\_metrics\_enabled](#input\_publish\_cloudwatch\_metrics\_enabled) | Whether to publish CloudWatch metrics for the workgroup | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_tags"></a> [tags](#output\_tags) | The tags assigned to the resource |
| <a name="output_workgroup_arn"></a> [workgroup\_arn](#output\_workgroup\_arn) | The ARN of the Athena workgroup |
| <a name="output_workgroup_id"></a> [workgroup\_id](#output\_workgroup\_id) | The ID of the Athena workgroup |
| <a name="output_workgroup_name"></a> [workgroup\_name](#output\_workgroup\_name) | The name of the Athena workgroup |

<!-- END_TF_DOCS -->