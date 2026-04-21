# aws/base_component/ssm

Opinionated SSM Parameter module. Enforces `SecureString` with CMK encryption.

## Features

- `aws_ssm_parameter` of type `SecureString`
- Mandatory `key_id` (KMS CMK) for encryption
- Required tags enforced

## Usage

```hcl
module "ssm" {
  source = "./aws/base_component/ssm"

  name        = "/app/prod/db_password"
  description = "Database password for prod"
  value       = "supersecret"
  key_id      = "arn:aws:kms:us-east-1:123456789012:key/..."

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
| `name` | The name of the SSM parameter | `string` | n/a | yes |
| `description` | The description of the SSM parameter | `string` | n/a | yes |
| `value` | The value of the SSM parameter | `string` | n/a | yes |
| `key_id` | The KMS key ID or ARN to use for encryption | `string` | n/a | yes |
| `tags` | A map of tags to assign to the resources. Required keys: `environment`, `owner`, `project`, `cost_center`. | `map(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| `parameter_arn` | The ARN of the SSM parameter |
| `parameter_name` | The name of the SSM parameter |
