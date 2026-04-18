# aws/base_component/kms

> **Status: Backlog** — Implementation pending. See `.Jules/backlog.md` for requirements and acceptance criteria.

Opinionated KMS Customer Managed Key (CMK) module. Creates a KMS key with rotation enabled, a configurable deletion window, and least-privilege key policies.

## Features

- Key rotation enabled by default
- Deletion window configurable (default: 30 days)
- Key alias created automatically
- Key policy supports configurable admin and usage principals
- Required tags enforced

## Usage

```hcl
module "kms" {
  source = "./aws/base_component/kms"

  alias       = "alias/my-app-key"
  description = "CMK for my-app S3 and Lambda encryption"

  admin_principals = ["arn:aws:iam::123456789012:role/KMSAdminRole"]
  usage_principals = ["arn:aws:iam::123456789012:role/AppRole"]

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
| `alias` | KMS key alias (must start with alias/) | `string` | yes |
| `description` | Description of the KMS key | `string` | yes |
| `deletion_window_in_days` | Key deletion window in days (7-30) | `number` | no (default: 30) |
| `admin_principals` | IAM ARNs that can administer the key | `list(string)` | yes |
| `usage_principals` | IAM ARNs that can use the key for crypto | `list(string)` | yes |
| `tags` | Tags to apply to all resources | `map(string)` | yes |

## Outputs

| Name | Description |
|------|-------------|
| `key_id` | KMS key ID |
| `key_arn` | KMS key ARN |
| `key_alias_arn` | KMS key alias ARN |
