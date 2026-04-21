# aws/base_component/sqs

Opinionated SQS queue module. Enforces CMK encryption and supports dead-letter queues.

## Features

- `aws_sqs_queue` with configurable name and visibility timeout
- Mandatory `kms_key_arn` for encryption (SSE-KMS)
- `sqs_managed_sse_enabled` set to `false` (favor CMK)
- Optional dead-letter queue (DLQ) support
- Required tags enforced

## Usage

```hcl
module "sqs" {
  source = "./aws/base_component/sqs"

  name        = "my-queue"
  kms_key_arn = "arn:aws:kms:us-east-1:123456789012:key/..."

  use_dead_letter_queue = true

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
| `name` | The name of the SQS queue | `string` | n/a | yes |
| `visibility_timeout_seconds` | The visibility timeout for the queue | `number` | `30` | no |
| `kms_key_arn` | The ARN of the KMS key for encryption | `string` | n/a | yes |
| `use_dead_letter_queue` | Indicates whether to use a dead-letter queue | `bool` | `false` | no |
| `max_receive_count` | The number of times a message can be received before being sent to the dead-letter queue | `number` | `5` | no |
| `tags` | A map of tags to assign to the resources. Required keys: `environment`, `owner`, `project`, `cost_center`. | `map(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| `queue_arn` | The ARN of the SQS queue |
| `queue_url` | The URL of the SQS queue |
| `dlq_arn` | The ARN of the dead-letter queue |
