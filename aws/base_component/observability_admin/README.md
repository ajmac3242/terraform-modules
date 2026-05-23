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
| `telemetry_type` | The type of telemetry to collect (e.g., Logs, Metrics, Traces) | `string` | n/a | yes |
| `resource_type` | The type of resource to apply the rule to (e.g., AWS::Lambda::Function) | `string` | `null` | no |
| `tags` | Standard tags for all resources | `map(string)` | n/a | yes |

## Outputs
| Name | Description |
|------|-------------|
| `rule_arn` | The ARN of the telemetry rule |
| `rule_name` | The name of the telemetry rule |
| `tags` | A map of tags assigned to the resource |
