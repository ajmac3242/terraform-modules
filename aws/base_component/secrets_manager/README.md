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
