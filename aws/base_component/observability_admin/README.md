# aws/base_component/observability_admin

## Purpose
Opinionated Observability Admin module for managing telemetry rules across the organization. Standardizes telemetry collection and filtering for better observability posture.

## Usage
```hcl
module "observability_admin" {
  source = "./aws/base_component/observability_admin"

  rule_name      = "standard-telemetry-rule"
  telemetry_type = "Traces"
  resource_type  = "AWS::Lambda::Function"

  tags = {
    environment = "prod"
    owner       = "platform-team"
    project     = "observability"
    cost_center = "12345"
  }
}
```

## Security
- **Tagging**: Enforces standard organizational tags for resource tracking and cost attribution.
- **Least Privilege**: Managed via AWS Observability Admin feature.

## Variables
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `rule_name` | The name of the telemetry rule | `string` | n/a | yes |
| telemetry_type | The type of telemetry to collect (Logs, Metrics, Traces) | `string` | n/a | yes |
| `resource_type` | The type of resource to apply the rule to (e.g., AWS::Lambda::Function) | `string` | `null` | no |
| is_organization_rule | Whether to create the rule at the organizational level | `bool` | `false` | no |
| `tags` | Standard tags for all resources | `map(string)` | n/a | yes |

## Outputs
| Name | Description |
|------|-------------|
| `rule_arn` | The ARN of the telemetry rule |
| `rule_name` | The name of the telemetry rule |
| `tags` | A map of tags assigned to the resource |

<!-- BEGIN_TF_DOCS -->


## Usage

```hcl
# See README.md for usage example
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_rule_name"></a> [rule\_name](#input\_rule\_name) | The name of the telemetry rule | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to the resources | `map(string)` | n/a | yes |
| <a name="input_telemetry_type"></a> [telemetry\_type](#input\_telemetry\_type) | The type of telemetry to collect (e.g., Logs, Metrics, Traces) | `string` | n/a | yes |
| <a name="input_is_organization_rule"></a> [is\_organization\_rule](#input\_is\_organization\_rule) | Whether to create the rule at the organizational level | `bool` | `false` | no |
| <a name="input_resource_type"></a> [resource\_type](#input\_resource\_type) | The type of resource to apply the rule to (e.g., AWS::Lambda::Function) | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_rule_arn"></a> [rule\_arn](#output\_rule\_arn) | The ARN of the telemetry rule |
| <a name="output_rule_name"></a> [rule\_name](#output\_rule\_name) | The name of the telemetry rule |
| <a name="output_tags"></a> [tags](#output\_tags) | A map of tags assigned to the resource |

<!-- END_TF_DOCS -->