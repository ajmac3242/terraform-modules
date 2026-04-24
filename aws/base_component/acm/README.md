# aws/base_component/acm

Opinionated ACM Certificate module.

## Features

- ACM Certificate
- DNS or EMAIL validation support
- `create_before_destroy` lifecycle enabled
- Tags validation

## Usage

```hcl
module "acm" {
  source = "./aws/base_component/acm"

  domain_name       = "example.com"
  validation_method = "DNS"

  tags = {
    environment = "prod"
    owner       = "platform-team"
    project     = "my-app"
    cost_center = "CC-1234"
  }
}
```
