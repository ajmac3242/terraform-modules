# aws/base_component/kms

## Purpose
Opinionated KMS Customer Managed Key module. Foundational module for at-rest encryption across the organization. Centralizes key creation, rotation, and least-privilege key policies.

## Usage
```hcl
module "kms" {
  source = "./aws/base_component/kms"

  name        = "my-app-key"
  description = "Encryption key for my application"

  admin_principal_arns = ["arn:aws:iam::123456789012:role/admin"]
  usage_principal_arns = ["arn:aws:iam::123456789012:role/app-execution-role"]

  tags = {
    environment = "prod"
    owner       = "platform-team"
    project     = "standardization"
    cost_center = "12345"
  }
}
```

## Security
- **Rotation**: Automatic annual key rotation is enabled by default and cannot be disabled.
- **Policies**: Enforces least-privilege key policies by separating admin and usage principals. Denies all access if no principal is specified.
- **Alias**: Automatically creates an alias for the key using `alias/<name>`.

## Variables
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `name` | Name of the KMS key (used for alias) | `string` | n/a | yes |
| `description` | Description of the KMS key | `string` | n/a | yes |
| `admin_principal_arns` | List of IAM ARNs that can manage the key | `list(string)` | `[]` | no |
| `usage_principal_arns` | List of IAM ARNs that can use the key for encryption/decryption | `list(string)` | `[]` | no |
| `deletion_window_in_days` | Number of days before the key is deleted (7-30) | `number` | `30` | no |
| `multi_region` | Whether to create a multi-region key | `bool` | `false` | no |
| `tags` | Standard tags for all resources | `map(string)` | n/a | yes |

## Outputs
| Name | Description |
|------|-------------|
| `key_arn` | The ARN of the KMS key |
| `key_id` | The ID of the KMS key |
| `alias_arn` | The ARN of the KMS alias |
| `alias_name` | The name of the KMS alias |
