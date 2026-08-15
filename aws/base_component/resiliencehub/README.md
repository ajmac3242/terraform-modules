# AWS Resilience Hub Resiliency Policy Module

## Purpose
This module provisions a standardized AWS Resilience Hub Resiliency Policy (`aws_resiliencehub_resiliency_policy`). It defines explicit Recovery Time Objectives (RTO) and Recovery Point Objectives (RPO) targets for application disruptions, availability zone failures, hardware issues, and optional regional disruptions.

## Usage

```hcl
module "resilience_policy" {
  source = "../../base_component/resiliencehub"

  policy_name = "mission-critical-policy"
  tier        = "MissionCritical"
  description = "Resiliency policy for mission critical platform workloads"

  policy_az = {
    rpo = "1h"
    rto = "15m"
  }

  policy_hardware = {
    rpo = "1h"
    rto = "15m"
  }

  policy_software = {
    rpo = "1h"
    rto = "15m"
  }

  policy_region = {
    rpo = "24h"
    rto = "4h"
  }

  tags = {
    environment = "production"
    owner       = "platform-sre"
    project     = "core-infrastructure"
    cost_center = "cc-998877"
  }
}
```

## Security
- Enforces organizational tagging standards (`environment`, `owner`, `project`, `cost_center`).
- Establishes standardized business continuity baselines (RPO/RTO) across applications.
- Supports optional location constraints to align with organizational data sovereignty policies.

## Variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `policy_name` | The name of the Resilience Hub resiliency policy. | `string` | n/a | yes |
| `tier` | Severity tier for the policy (`MissionCritical`, `Critical`, `Important`, `CoreServices`, `NonCritical`). | `string` | n/a | yes |
| `description` | Description of the resiliency policy. | `string` | `null` | no |
| `data_location_constraint` | Geographical location constraint for resilience policy data. | `string` | `null` | no |
| `policy_az` | Target RTO and RPO for availability zone disruptions. | `object({ rpo = string, rto = string })` | n/a | yes |
| `policy_hardware` | Target RTO and RPO for infrastructure/hardware disruptions. | `object({ rpo = string, rto = string })` | n/a | yes |
| `policy_software` | Target RTO and RPO for application/software disruptions. | `object({ rpo = string, rto = string })` | n/a | yes |
| `policy_region` | Target RTO and RPO for regional disruptions. | `object({ rpo = string, rto = string })` | `null` | no |
| `tags` | Map of tags to assign to the policy. Must contain required keys. | `map(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| `policy_arn` | The Amazon Resource Name (ARN) of the Resilience Hub resiliency policy. |
| `policy_id` | The ID of the Resilience Hub resiliency policy. |
| `policy_name` | The name of the Resilience Hub resiliency policy. |
| `tags` | A map of tags assigned to the Resilience Hub resiliency policy. |
