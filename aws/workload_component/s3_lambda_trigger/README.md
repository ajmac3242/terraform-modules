# aws/workload_component/s3_lambda_trigger

## Purpose
S3 event notification + Lambda pattern. Common ingestion and object-processing pattern, composing secure S3 defaults with Lambda invocation wiring.

## Usage
```hcl
module "ingestor" {
  source = "./aws/workload_component/s3_lambda_trigger"

  bucket_name = "my-ingestion-bucket"
  filter_suffix = ".csv"
  kms_key_arn  = module.kms.key_arn

  tags = {
    environment = "prod"
    owner       = "platform-team"
    project     = "standardization"
    cost_center = "12345"
  }
}
```

## Security
- **Encryption**: Bucket uses CMK for at-rest encryption. Lambda also uses CMK for environment variables and logs.
- **Exposure Control**: S3 bucket has all public access blocked by default.
- **IAM**: Least-privilege execution role and bucket notification permissions.

## Variables
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `bucket_name` | Name of the S3 bucket | `string` | n/a | yes |
| `events` | List of S3 events that trigger the Lambda | `list(string)` | `["s3:ObjectCreated:*"]` | no |
| `filter_prefix` | Object key prefix filter | `string` | `null` | no |
| `filter_suffix` | Object key suffix filter | `string` | `null` | no |
| `kms_key_arn` | KMS key ARN for encryption | `string" | n/a | yes |
| `tags` | Standard tags for all resources | `map(string)` | n/a | yes |

## Outputs
| Name | Description |
|------|-------------|
| `bucket_arn` | The ARN of the S3 bucket |
| `function_arn` | The ARN of the Lambda function |
| `notification_configuration_id` | The ID of the S3 bucket notification configuration |
| `tags` | A map of tags assigned to the resources |

<!-- BEGIN_TF_DOCS -->


## Usage

```hcl
# See README.md for usage example
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | The name of the S3 bucket to create or use | `string` | n/a | yes |
| <a name="input_lambda_description"></a> [lambda\_description](#input\_lambda\_description) | The description of the Lambda function | `string` | n/a | yes |
| <a name="input_lambda_function_name"></a> [lambda\_function\_name](#input\_lambda\_function\_name) | The name of the Lambda function to create or use | `string` | n/a | yes |
| <a name="input_lambda_handler"></a> [lambda\_handler](#input\_lambda\_handler) | The Lambda function handler | `string` | n/a | yes |
| <a name="input_lambda_runtime"></a> [lambda\_runtime](#input\_lambda\_runtime) | The Lambda function runtime | `string` | n/a | yes |
| <a name="input_lambda_source_path"></a> [lambda\_source\_path](#input\_lambda\_source\_path) | The path to the Lambda function source code (zip file) | `string` | n/a | yes |
| <a name="input_log_bucket_id"></a> [log\_bucket\_id](#input\_log\_bucket\_id) | The ID of the S3 bucket to store access logs | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to the resources | `map(string)` | n/a | yes |
| <a name="input_events"></a> [events](#input\_events) | A list of S3 events that will trigger the Lambda function | `list(string)` | ```[ "s3:ObjectCreated:*" ]``` | no |
| <a name="input_filter_prefix"></a> [filter\_prefix](#input\_filter\_prefix) | The prefix filter for the S3 bucket notification | `string` | `null` | no |
| <a name="input_filter_suffix"></a> [filter\_suffix](#input\_filter\_suffix) | The suffix filter for the S3 bucket notification | `string` | `null` | no |
| <a name="input_lambda_vpc_config"></a> [lambda\_vpc\_config](#input\_lambda\_vpc\_config) | The VPC configuration for the Lambda function | ```object({ subnet_ids = list(string) security_group_ids = list(string) })``` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bucket_arn"></a> [bucket\_arn](#output\_bucket\_arn) | The ARN of the bucket |
| <a name="output_bucket_id"></a> [bucket\_id](#output\_bucket\_id) | The name of the bucket |
| <a name="output_function_arn"></a> [function\_arn](#output\_function\_arn) | The ARN of the Lambda function |
| <a name="output_function_name"></a> [function\_name](#output\_function\_name) | The name of the Lambda function |
| <a name="output_notification_id"></a> [notification\_id](#output\_notification\_id) | The ID of the S3 bucket notification |
| <a name="output_tags"></a> [tags](#output\_tags) | A map of tags assigned to the resources |

<!-- END_TF_DOCS -->