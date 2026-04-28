# aws/base_component/ssm

## Purpose
Opinionated SSM Parameter module. Standard secret and configuration management, enforcing `SecureString` with CMK encryption.

## Usage
```hcl
module "ssm_parameter" {
  source = "./aws/base_component/ssm"

  name   = "/app/config/db-password"
  value  = var.db_password
  key_id = module.kms.key_arn

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
| `key_id` | KMS key ID for encryption | `string` | n/a | yes |
| `description` | Description of the parameter | `string` | `null` | no |
| `tags` | Standard tags for all resources | `map(string)` | n/a | yes |

## Outputs
| Name | Description |
|------|-------------|
| `parameter_arn` | The ARN of the SSM parameter |
| `parameter_name` | The name of the SSM parameter |
| `parameter_version` | The version of the SSM parameter |
