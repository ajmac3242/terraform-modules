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

<!-- BEGIN_TF_DOCS -->


## Usage

```hcl
# See README.md for usage example
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | The ARN of the KMS key for encryption | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | The name of the SQS queue | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to the resources | `map(string)` | n/a | yes |
| <a name="input_max_receive_count"></a> [max\_receive\_count](#input\_max\_receive\_count) | The number of times a message can be received before being sent to the dead-letter queue | `number` | `5` | no |
| <a name="input_use_dead_letter_queue"></a> [use\_dead\_letter\_queue](#input\_use\_dead\_letter\_queue) | Indicates whether to use a dead-letter queue | `bool` | `false` | no |
| <a name="input_visibility_timeout_seconds"></a> [visibility\_timeout\_seconds](#input\_visibility\_timeout\_seconds) | The visibility timeout for the queue | `number` | `30` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dlq_arn"></a> [dlq\_arn](#output\_dlq\_arn) | The ARN of the dead-letter queue |
| <a name="output_queue_arn"></a> [queue\_arn](#output\_queue\_arn) | The ARN of the SQS queue |
| <a name="output_queue_url"></a> [queue\_url](#output\_queue\_url) | The URL of the SQS queue |
| <a name="output_tags"></a> [tags](#output\_tags) | A map of tags assigned to the resource |

<!-- END_TF_DOCS -->