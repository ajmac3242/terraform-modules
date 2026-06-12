# Security Hub

## Purpose
This module enables and configures AWS Security Hub, providing a centralized view of security findings and compliance status.

## Usage
```hcl
module "securityhub" {
  source = "./aws/base_component/securityhub"

  enable_finding_aggregator = true

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
| tags | Standard tags for all resources | `map(string)` | n/a | yes |

## Outputs
| Name | Description |
|------|-------------|
| securityhub_id | The ID of the Security Hub account |
| securityhub_arn | The ARN of the Security Hub account |
| finding_aggregator_id | The ID of the finding aggregator |
| `tags` | A map of tags assigned to the resources |

<!-- BEGIN_TF_DOCS -->


## Usage

```hcl
# See README.md for usage example
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to the resources | `map(string)` | n/a | yes |
| <a name="input_auto_enable_controls"></a> [auto\_enable\_controls](#input\_auto\_enable\_controls) | Whether to automatically enable new controls when they are added to standards that are enabled. | `bool` | `true` | no |
| <a name="input_control_finding_generator"></a> [control\_finding\_generator](#input\_control\_finding\_generator) | Updates whether the calling account has consolidated control findings turned on. (SECURITY\_CONTROL, STANDARD\_CONTROL) | `string` | `"SECURITY_CONTROL"` | no |
| <a name="input_enable_default_standards"></a> [enable\_default\_standards](#input\_enable\_default\_standards) | Whether to enable the security standards that Security Hub has designated as automatically enabled. | `bool` | `true` | no |
| <a name="input_enable_finding_aggregator"></a> [enable\_finding\_aggregator](#input\_enable\_finding\_aggregator) | Whether to enable cross-region finding aggregation. | `bool` | `false` | no |
| <a name="input_standards_subscriptions"></a> [standards\_subscriptions](#input\_standards\_subscriptions) | A list of standards ARNs to subscribe to. | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_finding_aggregator_id"></a> [finding\_aggregator\_id](#output\_finding\_aggregator\_id) | The ID of the finding aggregator |
| <a name="output_securityhub_arn"></a> [securityhub\_arn](#output\_securityhub\_arn) | The ARN of the Security Hub account |
| <a name="output_securityhub_id"></a> [securityhub\_id](#output\_securityhub\_id) | The ID of the Security Hub account |
| <a name="output_tags"></a> [tags](#output\_tags) | A map of tags assigned to the resources (returns var.tags as Security Hub resources do not support tags) |

<!-- END_TF_DOCS -->