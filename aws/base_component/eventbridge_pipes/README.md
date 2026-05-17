# EventBridge Pipes

## Purpose
This module provides an opinionated way to create Amazon EventBridge Pipes, enabling point-to-point integrations between event sources and targets with optional enrichment.

## Usage
```hcl
module "sqs_to_lambda" {
  source = "./aws/base_component/eventbridge_pipes"

  name       = "my-sqs-to-lambda-pipe"
  source_arn = aws_sqs_queue.source.arn
  target_arn = aws_lambda_function.target.arn

  tags = {
    environment = "prod"
    owner       = "platform-team"
    project     = "standardization"
    cost_center = "12345"
  }
}
```

## Security
- **IAM**: This module creates a least-privilege IAM execution role via the `aws/base_component/iam` module.
- **Encryption**: If used with SQS DLQs, CMK encryption is mandatory for those queues.

## Variables
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | The name of the EventBridge Pipe | `string` | n/a | yes |
| description | Description of the pipe | `string` | `null` | no |
| source_arn | The ARN of the source resource | `string` | n/a | yes |
| target_arn | The ARN of the target resource | `string` | n/a | yes |
| enrichment_arn | The ARN of the enrichment resource | `string` | `null` | no |
| source_parameters | Parameters for the source | `any` | `{}` | no |
| target_parameters | Parameters for the target | `any` | `{}` | no |
| enrichment_parameters | Parameters for the enrichment | `any` | `{}` | no |
| desired_state | The desired state of the pipe (RUNNING, STOPPED) | `string` | `"RUNNING"` | no |
| custom_policy_arns | Additional managed policy ARNs for the IAM role | `list(string)` | `[]` | no |
| tags | Standard tags for all resources | `map(string)` | n/a | yes |

## Outputs
| Name | Description |
|------|-------------|
| pipe_arn | The ARN of the EventBridge Pipe |
| pipe_id | The ID of the EventBridge Pipe |
| pipe_name | The name of the EventBridge Pipe |
| role_arn | The ARN of the IAM role created for the pipe |
| `tags` | A map of tags assigned to the resource |
