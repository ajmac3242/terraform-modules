# aws/base_component/s3

## Purpose
Opinionated S3 bucket module. Auto-enforcing CMK encryption, public access blocking, versioning, and TLS-only access to eliminate data exposure risks.

## Usage
```hcl
module "s3_bucket" {
  source = "./aws/base_component/s3"

  bucket_name = "my-secure-bucket"

  tags = {
    environment = "prod"
    owner       = "platform-team"
    project     = "standardization"
    cost_center = "12345"
  }
}
```

## Security
- **Encryption**: Enforces Server-Side Encryption using a Customer Managed Key (CMK). Auto-creates a key if `existing_kms_key_arn` is not provided.
- **Exposure Control**: All 4 Public Access Block settings are enabled by default. `aws:SecureTransport` (HTTPS) is enforced via bucket policy.
- **Ownership**: `OwnershipControls` is set to `BucketOwnerEnforced` (disables ACLs).
- **Logging**: Access logging is enabled by default if a `log_bucket_id` is provided.

## Variables
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `bucket_name` | Name of the S3 bucket | `string` | n/a | yes |
| `versioning_enabled` | Enable versioning for the bucket | `bool` | `true` | no |
| `existing_kms_key_arn` | ARN of an existing KMS key to use for encryption. If null, a new key is created. | `string` | `null` | no |
| `enable_access_logging` | Enable server access logging | `bool` | `true` | no |
| `log_bucket_id` | ID of the S3 bucket where access logs will be stored | `string` | `null` | no |
| `lifecycle_rules` | List of lifecycle rule definitions | `list(any)` | `[]` | no |
| `force_destroy` | Whether to allow the bucket to be destroyed even if it contains objects | `bool` | `false` | no |
| `tags` | Standard tags for all resources | `map(string)` | n/a | yes |

## Outputs
| Name | Description |
|------|-------------|
| `bucket_arn` | The ARN of the S3 bucket |
| `bucket_id` | The ID (name) of the S3 bucket |
| `bucket_regional_domain_name` | The bucket region-specific domain name |
| `kms_key_arn` | The ARN of the KMS key used for encryption |
| `kms_key_id` | The ID of the KMS key used for encryption |
| `tags` | The tags assigned to the resource |

<!-- BEGIN_TF_DOCS -->


## Usage

```hcl
# See README.md for usage example
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | The name of the S3 bucket | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to the resources | `map(string)` | n/a | yes |
| <a name="input_additional_policy_document"></a> [additional\_policy\_document](#input\_additional\_policy\_document) | An additional IAM policy document in JSON format to merge with the default SSL-only policy | `string` | `null` | no |
| <a name="input_aws_account_id"></a> [aws\_account\_id](#input\_aws\_account\_id) | The AWS Account ID to support tests/mocking | `string` | `null` | no |
| <a name="input_enable_access_logging"></a> [enable\_access\_logging](#input\_enable\_access\_logging) | Indicates whether access logging is enabled for the S3 bucket | `bool` | `true` | no |
| <a name="input_existing_kms_key_arn"></a> [existing\_kms\_key\_arn](#input\_existing\_kms\_key\_arn) | The ARN of an existing KMS CMK to use for SSE-KMS. If null, a new key will be created. | `string` | `null` | no |
| <a name="input_force_destroy"></a> [force\_destroy](#input\_force\_destroy) | Indicates whether all objects should be deleted from the bucket when the bucket is destroyed | `bool` | `false` | no |
| <a name="input_lifecycle_rules"></a> [lifecycle\_rules](#input\_lifecycle\_rules) | A list of lifecycle rules for the S3 bucket | `any` | `[]` | no |
| <a name="input_log_bucket_id"></a> [log\_bucket\_id](#input\_log\_bucket\_id) | The ID of the S3 bucket to receive access logs | `string` | `null` | no |
| <a name="input_versioning_enabled"></a> [versioning\_enabled](#input\_versioning\_enabled) | Indicates whether versioning is enabled for the S3 bucket | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bucket_arn"></a> [bucket\_arn](#output\_bucket\_arn) | The ARN of the bucket |
| <a name="output_bucket_id"></a> [bucket\_id](#output\_bucket\_id) | The name of the bucket |
| <a name="output_bucket_regional_domain_name"></a> [bucket\_regional\_domain\_name](#output\_bucket\_regional\_domain\_name) | The bucket region-specific domain name |
| <a name="output_kms_key_arn"></a> [kms\_key\_arn](#output\_kms\_key\_arn) | The ARN of the KMS key used for encryption |
| <a name="output_kms_key_id"></a> [kms\_key\_id](#output\_kms\_key\_id) | The ID of the KMS key used for encryption |
| <a name="output_tags"></a> [tags](#output\_tags) | The tags assigned to the resource |

<!-- END_TF_DOCS -->