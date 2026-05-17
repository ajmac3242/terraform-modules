# aws/base_component/sqs

## Purpose
Opinionated SQS queue module. Core messaging primitive with enforced CMK encryption.

## Usage
```hcl
module "sqs_queue" {
  source = "./aws/base_component/sqs"

  name             = "my-queue"
  kms_master_key_id = module.kms.key_arn

  tags = {
    environment = "prod"
    owner       = "platform-team"
    project     = "standardization"
    cost_center = "12345"
  }
}
```

## Security
- **Encryption**: Mandatory Server-Side Encryption using a Customer Managed Key (CMK). `sqs_managed_sse_enabled` is disabled in favor of CMK.
- **Access**: Controlled via resource-based policies. Supports dead-letter queues (DLQ) for failed message handling.

## Variables
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `name` | Name of the SQS queue | `string` | n/a | yes |
| `kms_master_key_id` | ARN for the KMS key to use for encryption | `string` | n/a | yes |
| `visibility_timeout_seconds` | The visibility timeout for the queue | `number` | `30` | no |
| `message_retention_seconds` | The number of seconds SQS retains a message | `number` | `345600` (4 days) | no |
| `redrive_policy` | JSON string for the dead-letter queue redrive policy | `string` | `null` | no |
| `tags` | Standard tags for all resources | `map(string)` | n/a | yes |

## Outputs
| Name | Description |
|------|-------------|
| `queue_arn` | The ARN of the SQS queue |
| `queue_url` | The URL of the SQS queue |
| `queue_id` | The ID of the SQS queue |
| `tags` | A map of tags assigned to the resource |
