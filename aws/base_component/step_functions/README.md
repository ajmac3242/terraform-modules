# aws/base_component/step_functions

Opinionated Step Functions State Machine module.

## Features

- Step Functions State Machine
- Mandatory CloudWatch logging with KMS encryption
- X-Ray tracing enabled
- Tags validation

## Usage

```hcl
module "step_functions" {
  source = "./aws/base_component/step_functions"

  name        = "my-state-machine"
  role_arn    = "arn:aws:iam::123456789012:role/my-sfn-role"
  kms_key_arn = module.kms.key_arn
  definition  = jsonencode({
    StartAt = "HelloWorld"
    States = {
      HelloWorld = {
        Type = "Pass"
        Result = "Hello, World!"
        End = true
      }
    }
  })

  tags = {
    environment = "prod"
    owner       = "platform-team"
    project     = "my-app"
    cost_center = "CC-1234"
  }
}
```
