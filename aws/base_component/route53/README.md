# aws/base_component/route53

## Purpose
Opinionated Route 53 module. Managed DNS records with standard validation and support for common record types.

## Usage
```hcl
module "dns_records" {
  source = "./aws/base_component/route53"

  zone_id = "Z1234567890"
  records = [
    {
      name = "www"
      type = "A"
      ttl  = 300
      records = ["1.2.3.4"]
    },
    {
      name = "app"
      type = "A"
      alias = {
        name                   = module.alb.dns_name
        zone_id                = module.alb.zone_id
        evaluate_target_health = true
      }
    }
  ]
}
```

## Security
- **Integrity**: Supports DNSSEC (if configured on the hosted zone).
- **Control**: Least-privilege IAM policies for DNS management.

## Variables
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `zone_id` | The ID of the hosted zone to contain the records | `string` | n/a | yes |
| `records` | List of record maps to create | `any` | `[]` | no |
| `tags` | Standard tags for all resources (Note: Route 53 records do not support tags, but this variable is included for consistency) | `map(string)` | `{}` | no |

## Outputs
| Name | Description |
|------|-------------|
| `record_names` | List of record names created |
| `record_fqdns` | List of FQDNs created |
| `tags` | A map of tags assigned to the resources |

<!-- BEGIN_TF_DOCS -->


## Usage

```hcl
# See README.md for usage example
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_records"></a> [records](#input\_records) | A list of records to create | ```list(object({ name = string type = string ttl = optional(number) records = optional(list(string)) alias = optional(object({ name = string zone_id = string evaluate_target_health = bool })) }))``` | n/a | yes |
| <a name="input_zone_id"></a> [zone\_id](#input\_zone\_id) | The ID of the hosted zone | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to the resources. Note: Route 53 records do not support tags, but this variable is required for consistency across modules. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_record_fqdns"></a> [record\_fqdns](#output\_record\_fqdns) | A list of FQDNs for the created records |
| <a name="output_record_ids"></a> [record\_ids](#output\_record\_ids) | A list of IDs for the created records |
| <a name="output_tags"></a> [tags](#output\_tags) | A map of tags assigned to the resources (returns var.tags as Route 53 records do not support tags) |

<!-- END_TF_DOCS -->