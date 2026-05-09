# AWS Backup Module

## Purpose
This module provides a standardized way to manage AWS Backup plans, vaults, and selections. It enforces security best practices such as mandatory CMK encryption for backup vaults and optional vault lock configuration for immutable backups.

## Usage
```hcl
module "backup" {
  source = "github.com/org/repo//aws/base_component/backup"

  name        = "my-app-backup"
  kms_key_arn = "arn:aws:kms:us-east-1:123456789012:key/my-key-id"

  rules = [
    {
      rule_name = "daily-backup"
      schedule  = "cron(0 12 * * ? *)"
      lifecycle = {
        delete_after = 30
      }
    }
  ]

  selection_resources = [
    "arn:aws:ec2:us-east-1:123456789012:instance/i-0123456789abcdef0"
  ]

  tags = {
    environment = "prod"
    owner       = "platform-team"
    project     = "infrastructure"
    cost_center = "12345"
  }
}
```

## Security
- **CMK Encryption**: Mandatory CMK encryption for the backup vault.
- **Least Privilege**: IAM role for AWS Backup is created with minimum required managed policies.
- **Vault Lock**: Supports `aws_backup_vault_lock_configuration` for immutable backups.
- **Public Access**: Backup vaults are not publicly accessible by default.

## Variables
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | The base name for the AWS Backup resources | `string` | n/a | yes |
| kms_key_arn | The ARN of the KMS key to use for the backup vault | `string` | n/a | yes |
| vault_lock_configuration | Optional configuration for AWS Backup Vault Lock | `object` | `null` | no |
| rules | A list of rules for the backup plan | `list(object)` | n/a | yes |
| selection_resources | A list of ARNs to assign to a backup plan | `list(string)` | `[]` | no |
| selection_tags | A list of tag-based selection criteria | `list(object)` | `[]` | no |
| tags | A map of tags to assign to the resources | `map(string)` | n/a | yes |

## Outputs
| Name | Description |
|------|-------------|
| vault_arn | The ARN of the backup vault |
| vault_id | The name of the backup vault |
| plan_id | The ID of the backup plan |
| plan_arn | The ARN of the backup plan |
| role_arn | The ARN of the IAM role used for AWS Backup |
| tags | A map of tags assigned to the resources |
