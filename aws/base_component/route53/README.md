# aws/base_component/route53

Opinionated Route 53 record module. Provides a consistent way to manage DNS records.

## Features

- Supports multiple records in a single module call
- Simple map-based configuration
- Required tags enforced (where applicable)

## Usage

```hcl
module "dns_records" {
  source = "./aws/base_component/route53"

  zone_id = "Z1234567890"
  records = [
    {
      name    = "www"
      type    = "A"
      ttl     = 300
      records = ["1.2.3.4"]
    }
  ]

  tags = {
    environment = "prod"
    owner       = "platform-team"
    project     = "infrastructure"
    cost_center = "CC-1234"
  }
}
```

## Inputs

| Name | Description | Type | Required |
|------|-------------|------|:--------:|
| `zone_id` | Hosted Zone ID | `string` | yes |
| `records` | List of record objects | `list(object)` | yes |
| `tags` | Map of tags | `map(string)` | yes |

## Outputs

| Name | Description |
|------|-------------|
| `record_fqdns` | List of FQDNs for created records |
