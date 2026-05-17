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
