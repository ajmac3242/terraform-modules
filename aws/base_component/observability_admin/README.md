# aws/base_component/observability_admin

## Purpose
Opinionated Observability Admin module for managing telemetry rules at both the account and organizational levels. Standardizes telemetry collection and filtering for better observability posture across the entire AWS environment.

## Usage
### Account-Level Rule
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

### Organizational-Level Rule
```hcl
module "observability_admin_org" {
  source = "./aws/base_component/observability_admin"

  rule_name            = "org-wide-telemetry"
  telemetry_type       = "Logs"
  is_organization_rule = true

  tags = {
    environment = "prod"
    owner       = "security-ops"
    project     = "compliance"
    cost_center = "10000"
  }
}
```

## Security
- **Tagging**: Enforces standard organizational tags for resource tracking and cost attribution.
- **Scope Control**: Supports both single-account and multi-account (organizational) telemetry governance.
- **Provider Pinning**: Requires AWS Provider ~> 6.46 for organizational rule support.

## Variables
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `rule_name` | The name of the telemetry rule | `string` | n/a | yes |
| `telemetry_type` | The type of telemetry to collect (Logs, Metrics, or Traces) | `string` | n/a | yes |
| `resource_type` | The type of resource to apply the rule to (e.g., AWS::Lambda::Function) | `string` | `null` | no |
| `is_organization_rule` | Whether to create the rule at the organizational level | `bool` | `false` | no |
| `tags` | Standard tags for all resources | `map(string)` | n/a | yes |

## Outputs
| Name | Description |
|------|-------------|
| `rule_arn` | The ARN of the telemetry rule |
| `rule_name` | The name of the telemetry rule |
| `tags` | A map of tags assigned to the resource |
