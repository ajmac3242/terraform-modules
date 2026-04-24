# aws/base_component/wafv2

Opinionated WAFv2 Web ACL module.

## Features

- WAFv2 Web ACL
- Default allow action
- Visibility configuration enabled
- Includes AWS Managed Common Rule Set
- Tags validation

## Usage

```hcl
module "waf" {
  source = "./aws/base_component/wafv2"

  name  = "my-waf"
  scope = "REGIONAL"

  tags = {
    environment = "prod"
    owner       = "platform-team"
    project     = "my-app"
    cost_center = "CC-1234"
  }
}
```
