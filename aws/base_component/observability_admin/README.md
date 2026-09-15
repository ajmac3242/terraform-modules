# aws/base_component/observability_admin

## Purpose
Opinionated Observability Admin module for managing telemetry rules across the organization. Standardizes telemetry collection, destination delivery (CloudTrail, ELB, Log Delivery, MSK, VPC Flow Logs, WAF), and filtering for better observability posture.

## Usage
```hcl
module "observability_admin" {
  source = "./aws/base_component/observability_admin"

  rule_name              = "standard-telemetry-rule"
  telemetry_type         = "Logs"
  resource_type          = "AWS::EC2::VPC"
  selection_criteria     = "Include"
  telemetry_source_types = ["VPC_FLOW_LOGS"]

  destination_configurations = [
    {
      destination_type    = "cloud-watch-logs"
      destination_pattern = "arn:aws:logs:us-east-1:123456789012:log-group:/aws/vpc/flow-logs"
      retention_in_days   = 30
      vpc_flow_log_parameters = {
        traffic_type             = "ALL"
        max_aggregation_interval = 60
        log_format               = "$${version} $${account-id} $${interface-id} $${srcaddr} $${dstaddr} $${srcport} $${dstport} $${protocol} $${packets} $${bytes} $${start} $${end} $${action} $${log-status}"
      }
    }
  ]

  tags = {
    environment = "prod"
    owner       = "platform-team"
    project     = "observability"
    cost_center = "12345"
  }
}
```

## Security
- **CMK Encryption**: Underlying telemetry log destinations (e.g., CloudWatch Log Groups, S3 buckets, Kinesis Firehose streams) must enforce CMK encryption on their respective resources.
- **Tagging**: Enforces standard organizational tags (`environment`, `owner`, `project`, `cost_center`) for resource tracking and cost attribution.
- **Least Privilege**: Managed via AWS Observability Admin feature and structured rule scopes.

## Variables
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `rule_name` | The name of the telemetry rule | `string` | n/a | yes |
| `telemetry_type` | The type of telemetry to collect (Logs, Metrics, Traces) | `string` | n/a | yes |
| `resource_type` | The type of resource to apply the rule to (e.g., AWS::Lambda::Function) | `string` | `null` | no |
| `selection_criteria` | Selection criteria for telemetry data filtering | `string` | `null` | no |
| `telemetry_source_types` | List of telemetry source types | `list(string)` | `null` | no |
| `scope` | The scope of the telemetry rule | `string` | `null` | no |
| `all_regions` | Whether to apply the rule across all regions | `bool` | `null` | no |
| `regions` | List of regions to apply the rule to | `list(string)` | `null` | no |
| `allow_field_updates` | Whether to allow field updates for the rule | `bool` | `null` | no |
| `destination_configurations` | List of destination configurations for telemetry delivery (CloudTrail, ELB, Log Delivery, MSK, VPC Flow Logs, WAF) | `list(object)` | `[]` | no |
| `is_organization_rule` | Whether to create the rule at the organizational level | `bool` | `false` | no |
| `tags` | Standard tags for all resources | `map(string)` | n/a | yes |

## Outputs
| Name | Description |
|------|-------------|
| `rule_arn` | The ARN of the telemetry rule |
| `rule_name` | The name of the telemetry rule |
| `tags` | A map of tags assigned to the resource |
