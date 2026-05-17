# aws/base_component/sns

## Purpose
Opinionated SNS Topic module. Core messaging component with enforced CMK encryption.

## Usage
```hcl
module "sns_topic" {
  source = "./aws/base_component/sns"

  name        = "my-topic"
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
- **Encryption**: Mandatory Server-Side Encryption using a Customer Managed Key (CMK).
- **Access**: Least-privilege topic policies are recommended.

## Variables
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `name` | Name of the SNS topic | `string` | n/a | yes |
| `kms_key_arn` | ARN for the KMS key to use for encryption | `string` | n/a | yes |
| `tags` | Standard tags for all resources | `map(string)` | n/a | yes |

## Outputs
| Name | Description |
|------|-------------|
| `topic_arn` | The ARN of the SNS topic |
| `topic_name` | The name of the SNS topic |
| `tags` | A map of tags assigned to the resource |
