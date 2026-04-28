# aws/workload_component/eventbridge_lambda

## Purpose
EventBridge rule + Lambda pattern. Common event-driven workload pattern, composing EventBridge, Lambda, IAM, and optional DLQ for secure event processing.

## Usage
```hcl
module "worker" {
  source = "./aws/workload_component/eventbridge_lambda"

  name           = "my-event-worker"
  event_pattern  = jsonencode({ source = ["my.app"] })
  kms_key_arn    = module.kms.key_arn

  tags = {
    environment = "prod"
    owner       = "platform-team"
    project     = "standardization"
    cost_center = "12345"
  }
}
```

## Security
- **Encryption**: Lambda environment variables and logs are encrypted via CMK. EventBridge bus encryption is also enforced.
- **IAM**: Lambda execution role is scoped to least-privilege. API GW / EventBridge invoke permissions are tightly scoped.
- **Resilience**: Supports optional SQS dead-letter queue (DLQ) for failed event deliveries.

## Variables
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `name` | Name of the rule and Lambda function | `string` | n/a | yes |
| `event_bus_name` | Name of the event bus | `string` | `"default"` | no |
| `event_pattern` | Event pattern for the rule | `string` | `null` | no |
| `schedule_expression` | Schedule expression for the rule | `string` | `null` | no |
| `kms_key_arn` | KMS key ARN for encryption | `string` | n/a | yes |
| `tags` | Standard tags for all resources | `map(string)` | n/a | yes |

## Outputs
| Name | Description |
|------|-------------|
| `rule_arn` | The ARN of the EventBridge rule |
| `function_arn` | The ARN of the Lambda function |
| `function_name` | The name of the Lambda function |
| `target_id` | The ID of the EventBridge target |
