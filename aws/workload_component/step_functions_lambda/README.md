# aws/workload_component/step_functions_lambda

## Purpose
Step Functions + Lambda orchestration pattern. Valuable for multi-step serverless processes, reducing custom wiring and promoting repeatable IAM and logging patterns.

## Usage
```hcl
module "orchestration" {
  source = "./aws/workload_component/step_functions_lambda"

  name       = "my-workflow"
  definition = jsonencode({ ... })
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
- **Encryption**: CloudWatch logging for the state machine is encrypted via CMK. Lambda also uses CMK.
- **Observability**: X-Ray tracing is enabled by default.
- **IAM**: Execution roles for both Step Functions and Lambda are scoped to least-privilege.

## Variables
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `name` | Name of the state machine and related resources | `string` | n/a | yes |
| `definition` | JSON-encoded definition of the state machine | `string` | n/a | yes |
| `kms_key_arn` | KMS key ARN for encryption | `string` | n/a | yes |
| `tags` | Standard tags for all resources | `map(string)` | n/a | yes |

## Outputs
| Name | Description |
|------|-------------|
| `state_machine_arn` | The ARN of the state machine |
| `state_machine_name` | The name of the state machine |
| `lambda_function_arns` | List of Lambda function ARNs associated with the pattern |
| `tags` | A map of tags assigned to the resources |
