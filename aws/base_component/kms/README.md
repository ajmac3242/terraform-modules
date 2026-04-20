# aws/base_component/kms

Opinionated KMS Customer Managed Key (CMK) module. Creates a KMS key with rotation enabled, a configurable deletion window, and least-privilege key policies.

## Features

- Key rotation enabled by default (non-configurable)
- Deletion window configurable (14-30 days)
- Key alias created automatically as `alias/${var.name}`
- Least-privilege key policy with separate admin and usage principals
- Multi-region support
- Required tags enforced (environment, owner, project, cost_center)

## Usage

```hcl
module "kms" {
  source = "./aws/base_component/kms"

  name        = "my-app-key"
  description = "CMK for my-app S3 and Lambda encryption"

  admin_principal_arns = ["arn:aws:iam::123456789012:role/KMSAdminRole"]
  usage_principal_arns = ["arn:aws:iam::123456789012:role/AppRole"]

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
| `name` | The name of the KMS key (used for the alias prefix `alias/`) | `string` | n/a | yes |
| `description` | The description of the KMS key | `string` | n/a | yes |
| `admin_principal_arns` | A list of IAM ARNs that are allowed to administer the KMS key | `list(string)` | n/a | yes |
| `usage_principal_arns` | A list of IAM ARNs that are allowed to use the KMS key for cryptographic operations | `list(string)` | n/a | yes |
| `tags` | A map of tags to assign to the resources. Required keys: environment, owner, project, cost_center. | `map(string)` | n/a | yes |
| `aws_account_id` | The AWS Account ID to use for the key policy. If not provided, it is looked up via a data source. | `string` | `null` | no |
| `deletion_window_in_days` | The waiting period, specified in number of days. (14-30) | `number` | `30` | no |
| `multi_region` | Indicates whether the KMS key is a multi-Region (true) or regional (false) key | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| `key_id` | The ID of the KMS key |
| `key_arn` | The ARN of the KMS key |
| `alias_arn` | The ARN of the KMS key alias |
| `alias_name` | The name of the KMS key alias |
