# aws/base_component/eventbridge

Opinionated EventBridge Bus module.

## Features

- EventBridge Custom Bus
- Mandatory KMS encryption with CMK
- Tags validation

## Usage

```hcl
module "eventbridge" {
  source = "./aws/base_component/eventbridge"

  name        = "my-bus"
  kms_key_arn = module.kms.key_arn

  tags = {
    environment = "prod"
    owner       = "platform-team"
    project     = "my-app"
    cost_center = "CC-1234"
  }
}
```
