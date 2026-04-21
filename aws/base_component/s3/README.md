# aws/base_component/s3

Opinionated S3 bucket module. Enforces CMK encryption, public access blocking, versioning, access logging, and SSL-only bucket policy by default.

## Features

- CMK KMS encryption enforced (accepts `existing_kms_key_arn`)
- All public access blocked
- Versioning enabled by default
- Access logging to a configurable logging bucket
- SSL-only bucket policy enforced
- Ownership controls set to `BucketOwnerEnforced` (no ACLs)
- Configurable lifecycle rules
- Required tags enforced

## Usage

```hcl
module "s3" {
  source = "./aws/base_component/s3"

  bucket_name          = "my-app-data-prod"
  existing_kms_key_arn = "arn:aws:kms:us-east-1:123456789012:key/..."
  enable_access_logging = true
  log_bucket_id         = "my-app-access-logs-prod"

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
| `bucket_name` | The name of the S3 bucket | `string` | n/a | yes |
| `existing_kms_key_arn` | The ARN of an existing KMS CMK to use for SSE-KMS | `string` | `null` | yes |
| `versioning_enabled` | Indicates whether versioning is enabled for the S3 bucket | `bool` | `true` | no |
| `enable_access_logging` | Indicates whether access logging is enabled for the S3 bucket | `bool` | `false` | no |
| `log_bucket_id` | The ID of the S3 bucket to receive access logs | `string` | `null` | no |
| `force_destroy` | Indicates whether all objects should be deleted from the bucket when the bucket is destroyed | `bool` | `false` | no |
| `lifecycle_rules` | A list of lifecycle rules for the S3 bucket | `any` | `[]` | no |
| `tags` | A map of tags to assign to the resources. Required keys: `environment`, `owner`, `project`, `cost_center`. | `map(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| `bucket_id` | The name of the bucket |
| `bucket_arn` | The ARN of the bucket |
| `kms_key_arn` | The ARN of the KMS key used for encryption |
