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
| `kms_key_arn` | The ARN of the KMS key used for encryption |
