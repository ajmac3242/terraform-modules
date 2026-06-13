# aws/base_component/secrets_manager

## Purpose
Opinionated Secrets Manager module. Secure storage of secrets with mandatory CMK encryption and enforced recovery window.

## Usage
```hcl
module "secret" {
  source = "./aws/base_component/secrets_manager"

  name        = "my-app-secret"
  description = "Sensitive credentials for my application"
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
- **Encryption**: Mandatory encryption using a Customer Managed Key (CMK).
- **Recovery**: Enforces a 30-day recovery window for deleted secrets (`recovery_window_in_days`).
- **Access**: Controlled via resource-based policies (optional) and IAM.

## Variables
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `name` | Name of the secret | `string` | n/a | yes |
| `description` | Description of the secret | `string` | n/a | yes |
| `kms_key_arn` | ARN of the KMS key to be used to encrypt the secret values | `string` | n/a | yes |
| `recovery_window_in_days` | Number of days to retain deleted secrets (7-30) | `number` | `30` | no |
| `tags` | Standard tags for all resources | `map(string)` | n/a | yes |

## Outputs
| Name | Description |
|------|-------------|
| `secret_arn` | The ARN of the secret |
| `secret_id` | The ID of the secret |
| `tags` | A map of tags assigned to the resource |

<!-- BEGIN_TF_DOCS -->


## Usage

```hcl
# See README.md for usage example
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_description"></a> [description](#input\_description) | The description of the secret | `string` | n/a | yes |
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | The ARN of the KMS key for encryption | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | The name of the secret | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to the resources | `map(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_secret_arn"></a> [secret\_arn](#output\_secret\_arn) | The ARN of the secret |
| <a name="output_secret_id"></a> [secret\_id](#output\_secret\_id) | The ID of the secret |
| <a name="output_tags"></a> [tags](#output\_tags) | A map of tags assigned to the resource |

<!-- END_TF_DOCS -->