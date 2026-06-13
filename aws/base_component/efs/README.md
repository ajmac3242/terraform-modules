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

<!-- BEGIN_TF_DOCS -->


## Usage

```hcl
# See README.md for usage example
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | The ARN of the KMS key for encryption | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | The name of the file system | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to the resources | `map(string)` | n/a | yes |
| <a name="input_performance_mode"></a> [performance\_mode](#input\_performance\_mode) | The file system performance mode. Can be generalPurpose or maxIO | `string` | `"generalPurpose"` | no |
| <a name="input_throughput_mode"></a> [throughput\_mode](#input\_throughput\_mode) | Throughput mode for the file system. Valid values: bursting, provisioned, or elastic | `string` | `"elastic"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_efs_arn"></a> [efs\_arn](#output\_efs\_arn) | The ARN of the EFS file system |
| <a name="output_efs_dns_name"></a> [efs\_dns\_name](#output\_efs\_dns\_name) | The DNS name of the EFS file system |
| <a name="output_efs_id"></a> [efs\_id](#output\_efs\_id) | The ID of the EFS file system |
| <a name="output_kms_key_arn"></a> [kms\_key\_arn](#output\_kms\_key\_arn) | The KMS key ARN used for encryption |
| <a name="output_tags"></a> [tags](#output\_tags) | A map of tags assigned to the resource |

<!-- END_TF_DOCS -->