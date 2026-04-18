# aws/base_component/s3

> **Status: Backlog** — Implementation pending. See `.Jules/backlog.md` for requirements and acceptance criteria.

Opinionated S3 bucket module. Enforces CMK encryption, public access blocking, versioning, access logging, and SSL-only bucket policy by default.

## Features

- CMK KMS encryption enforced (requires `aws/base_component/kms` or accepts `kms_key_arn`)
- All public access blocked
- Versioning enabled by default
- Access logging to a configurable logging bucket
- SSL-only bucket policy enforced
- Configurable lifecycle rules
- Required tags enforced

## Usage

```hcl
module "s3" {
  source = "./aws/base_component/s3"

  bucket_name     = "my-app-data-prod"
  kms_key_arn     = module.kms.key_arn
  logging_bucket  = "my-app-access-logs-prod"

  tags = {
    environment = "prod"
    owner       = "platform-team"
    project     = "my-app"
    cost_center = "CC-1234"
  }
}
```

## Inputs

| Name | Description | Type | Required |
|------|-------------|------|----------|
| `bucket_name` | Name of the S3 bucket | `string` | yes |
| `kms_key_arn` | ARN of KMS CMK for bucket encryption | `string` | yes |
| `logging_bucket` | Name of S3 bucket to receive access logs | `string` | yes |
| `versioning_enabled` | Enable S3 versioning | `bool` | no (default: true) |
| `lifecycle_rules` | List of lifecycle rule configurations | `any` | no |
| `tags` | Tags to apply to all resources | `map(string)` | yes |

## Outputs

| Name | Description |
|------|-------------|
| `bucket_id` | S3 bucket name |
| `bucket_arn` | S3 bucket ARN |
| `bucket_domain_name` | S3 bucket domain name |
