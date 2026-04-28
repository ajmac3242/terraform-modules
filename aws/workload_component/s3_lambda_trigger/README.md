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
