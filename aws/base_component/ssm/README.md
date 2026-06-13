# aws/base_component/ssm

## Purpose
Opinionated SSM Parameter module. Standard secret and configuration management, enforcing `SecureString` with CMK encryption.

## Usage
```hcl
module "ssm_parameter" {
  source = "./aws/base_component/ssm"

  name        = "/app/config/db-password"
  value       = var.db_password
  kms_key_arn = module.kms.key_arn

  tags = {
    environment = "prod"
    owner       = "platform-team"
    project     = "standardization"
    cost_center = "12345"
  }
}
```

## Security
- **Encryption**: Enforces `type = "SecureString"` and requires a Customer Managed Key (CMK) for encryption.
- **Access**: Controlled via IAM policies. Parameter names are validated.

## Variables
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `name` | Name of the parameter | `string` | n/a | yes |
| `value` | Value of the parameter | `string` | n/a | yes |
| `kms_key_arn` | KMS key ARN for encryption | `string` | n/a | yes |
| `description` | Description of the parameter | `string` | `null` | no |
| `tags` | Standard tags for all resources | `map(string)` | n/a | yes |

## Outputs
| Name | Description |
|------|-------------|
| `parameter_arn` | The ARN of the SSM parameter |
| `parameter_name` | The name of the SSM parameter |
| `parameter_version` | The version of the SSM parameter |
| `tags` | A map of tags assigned to the resource |

<!-- BEGIN_TF_DOCS -->


## Usage

```hcl
# See README.md for usage example
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_description"></a> [description](#input\_description) | The description of the SSM parameter | `string` | n/a | yes |
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | The KMS key ARN to use for encryption | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | The name of the SSM parameter | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to the resources | `map(string)` | n/a | yes |
| <a name="input_value"></a> [value](#input\_value) | The value of the SSM parameter | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_parameter_arn"></a> [parameter\_arn](#output\_parameter\_arn) | The ARN of the SSM parameter |
| <a name="output_parameter_name"></a> [parameter\_name](#output\_parameter\_name) | The name of the SSM parameter |
| <a name="output_tags"></a> [tags](#output\_tags) | A map of tags assigned to the resource |

<!-- END_TF_DOCS -->