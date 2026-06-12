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

<!-- BEGIN_TF_DOCS -->


## Usage

```hcl
# See README.md for usage example
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | The name of the EventBridge Pipe | `string` | n/a | yes |
| <a name="input_source_arn"></a> [source\_arn](#input\_source\_arn) | The ARN of the source resource (e.g., SQS, DynamoDB Stream, Kinesis Stream) | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to the pipe | `map(string)` | n/a | yes |
| <a name="input_target_arn"></a> [target\_arn](#input\_target\_arn) | The ARN of the target resource (e.g., Lambda, Step Functions, EventBridge) | `string` | n/a | yes |
| <a name="input_custom_policy_arns"></a> [custom\_policy\_arns](#input\_custom\_policy\_arns) | A list of additional managed policy ARNs to attach to the pipe IAM role | `list(string)` | `[]` | no |
| <a name="input_description"></a> [description](#input\_description) | Description of the pipe | `string` | `null` | no |
| <a name="input_desired_state"></a> [desired\_state](#input\_desired\_state) | The desired state of the pipe (RUNNING, STOPPED) | `string` | `"RUNNING"` | no |
| <a name="input_enrichment_arn"></a> [enrichment\_arn](#input\_enrichment\_arn) | The ARN of the enrichment resource (e.g., Lambda, Step Functions) | `string` | `null` | no |
| <a name="input_enrichment_parameters"></a> [enrichment\_parameters](#input\_enrichment\_parameters) | Parameters for the enrichment | `any` | `{}` | no |
| <a name="input_source_parameters"></a> [source\_parameters](#input\_source\_parameters) | Parameters for the source | `any` | `{}` | no |
| <a name="input_target_parameters"></a> [target\_parameters](#input\_target\_parameters) | Parameters for the target | `any` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_pipe_arn"></a> [pipe\_arn](#output\_pipe\_arn) | The ARN of the EventBridge Pipe |
| <a name="output_pipe_id"></a> [pipe\_id](#output\_pipe\_id) | The ID of the EventBridge Pipe |
| <a name="output_pipe_name"></a> [pipe\_name](#output\_pipe\_name) | The name of the EventBridge Pipe |
| <a name="output_role_arn"></a> [role\_arn](#output\_role\_arn) | The ARN of the IAM role created for the pipe |
| <a name="output_tags"></a> [tags](#output\_tags) | A map of tags assigned to the resource |

<!-- END_TF_DOCS -->