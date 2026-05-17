# aws/base_component/efs

## Purpose
Opinionated EFS File System module. Secure elastic file storage with mandatory encryption and backup policy.

## Usage
```hcl
module "efs" {
  source = "./aws/base_component/efs"

  creation_token = "my-efs"
  kms_key_id     = module.kms.key_arn

  tags = {
    environment = "prod"
    owner       = "platform-team"
    project     = "standardization"
    cost_center = "12345"
  }
}
```

## Security
- **Encryption**: Mandatory CMK encryption for data at rest.
- **Backup**: `aws_efs_backup_policy` is set to `ENABLED` by default.
- **Network**: Placed in private VPC subnets via mount targets (configured separately or via a higher-level module).

## Variables
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `creation_token` | A unique name used as reference when creating the File System | `string` | n/a | yes |
| `kms_key_id` | ARN for the KMS key to use for encryption | `string` | n/a | yes |
| `performance_mode` | The file system performance mode | `string` | `"generalPurpose"` | no |
| `throughput_mode` | Throughput mode for the file system | `string` | `"bursting"` | no |
| `tags` | Standard tags for all resources | `map(string)` | n/a | yes |

## Outputs
| Name | Description |
|------|-------------|
| `file_system_arn` | The ARN of the EFS File System |
| `file_system_id` | The ID of the EFS File System |
| `dns_name` | The DNS name of the EFS File System |
| `tags` | A map of tags assigned to the resource |
