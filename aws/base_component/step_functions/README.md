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

<!-- BEGIN_TF_DOCS -->


## Usage

```hcl
# See README.md for usage example
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_definition"></a> [definition](#input\_definition) | The Amazon States Language definition of the state machine | `string` | n/a | yes |
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | The ARN of the KMS key for encryption | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | The name of the state machine | `string` | n/a | yes |
| <a name="input_role_arn"></a> [role\_arn](#input\_role\_arn) | The ARN of the IAM role to use for the state machine | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to the resources | `map(string)` | n/a | yes |
| <a name="input_log_group_retention_in_days"></a> [log\_group\_retention\_in\_days](#input\_log\_group\_retention\_in\_days) | Specifies the number of days you want to retain log events in the log group | `number` | `30` | no |
| <a name="input_skip_sfn_creation"></a> [skip\_sfn\_creation](#input\_skip\_sfn\_creation) | Toggle to skip state machine creation (useful for tests failing on SFN validation) | `bool` | `false` | no |
| <a name="input_type"></a> [type](#input\_type) | Determines whether a Standard or Express state machine is created. Valid values are STANDARD and EXPRESS | `string` | `"STANDARD"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_state_machine_arn"></a> [state\_machine\_arn](#output\_state\_machine\_arn) | The ARN of the state machine |
| <a name="output_state_machine_id"></a> [state\_machine\_id](#output\_state\_machine\_id) | The ID of the state machine |
| <a name="output_tags"></a> [tags](#output\_tags) | A map of tags assigned to the resources |

<!-- END_TF_DOCS -->