# aws/base_component/sns

Opinionated SNS topic module. Enforces CMK encryption.

## Features

- `aws_sns_topic` with mandatory CMK encryption
- Required tags enforced

## Usage

```hcl
module "sns" {
  source = "./aws/base_component/sns"

  name       = "my-topic"
  kms_key_id = module.kms.key_arn

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
| `name` | The name of the SNS topic | `string` | yes |
| `kms_key_id` | ARN of the KMS key | `string` | yes |
| `tags` | Map of tags | `map(string)` | yes |

## Outputs

| Name | Description |
|------|-------------|
| `topic_arn` | The ARN of the SNS topic |
