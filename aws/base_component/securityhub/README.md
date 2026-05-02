# Security Hub

## Purpose
This module enables and configures AWS Security Hub, providing a centralized view of security findings and compliance status.

## Usage
```hcl
module "securityhub" {
  source = "../../aws/base_component/securityhub"

  enable_finding_aggregator = true
  finding_aggregation_region = "us-east-1"

  tags = {
    environment = "prod"
    owner       = "security-team"
    project     = "standardization"
    cost_center = "12345"
  }
}
```

## Security
- **Findings Consolidated**: By default, `control_finding_generator` is set to `SECURITY_CONTROL` to consolidate findings across standards.
- **Aggregation**: Supports cross-region finding aggregation to a single region.

## Variables
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| enable_default_standards | Whether to enable default standards | `bool` | `true` | no |
| control_finding_generator | Consolidate control findings | `string` | `"SECURITY_CONTROL"` | no |
| auto_enable_controls | Automatically enable new controls | `bool` | `true` | no |
| standards_subscriptions | List of standards ARNs to subscribe to | `list(string)` | `[]` | no |
| enable_finding_aggregator | Enable finding aggregation | `bool` | `false` | no |
| finding_aggregation_region | Region to aggregate findings in | `string` | `null` | no |
| tags | Standard tags for all resources | `map(string)` | n/a | yes |

## Outputs
| Name | Description |
|------|-------------|
| securityhub_id | The ID of the Security Hub account |
| finding_aggregator_id | The ID of the finding aggregator |
