# aws/base_component/secrets_manager

Opinionated Secrets Manager module. Enforces CMK encryption and standard recovery window.

## Features

- `aws_secretsmanager_secret` with mandatory CMK encryption
- 30-day recovery window enforced
- Required tags enforced

## Usage

```hcl
module "secret" {
  source = "./aws/base_component/secrets_manager"

  name        = "app/prod/api-key"
  description = "API key for external service"
  kms_key_id  = module.kms.key_arn

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
|------|-------------|------|:--------:|
| `name` | The name of the secret | `string` | yes |
| `description` | Secret description | `string` | yes |
| `kms_key_id` | ARN of the KMS key | `string` | yes |
| `tags` | Map of tags | `map(string)` | yes |

## Outputs

| Name | Description |
|------|-------------|
| `secret_arn` | The ARN of the secret |
| `secret_id` | The ID of the secret |
