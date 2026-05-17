# aws/base_component/step_functions

## Purpose
Opinionated Step Functions module. Orchestration primitive with mandatory logging, tracing, and encryption.

## Usage
```hcl
module "state_machine" {
  source = "./aws/base_component/step_functions"

  name       = "my-orchestration"
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
- **Encryption**: CloudWatch Log Groups used for state machine execution logs are encrypted with a Customer Managed Key (CMK).
- **Observability**: X-Ray tracing is enabled by default. Logging is mandatory.
- **IAM**: Execution roles are scoped to least-privilege.

## Variables
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `name` | Name of the state machine | `string` | n/a | yes |
| `definition` | JSON-encoded definition of the state machine | `string` | n/a | yes |
| `kms_key_arn` | KMS key ARN for log group encryption | `string` | n/a | yes |
| `role_arn` | ARN of the IAM role for the state machine. If null, a role is created. | `string` | `null` | no |
| `tags` | Standard tags for all resources | `map(string)` | n/a | yes |

## Outputs
| Name | Description |
|------|-------------|
| `state_machine_arn` | The ARN of the state machine |
| `state_machine_id` | The ID of the state machine |
| `log_group_name` | The name of the CloudWatch log group |
| `tags` | A map of tags assigned to the resources |
