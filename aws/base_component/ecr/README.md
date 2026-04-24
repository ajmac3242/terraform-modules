# aws/base_component/ecr

Opinionated ECR Repository module.

## Features

- ECR Repository
- Mandatory KMS encryption with CMK
- Mandatory image scanning on push
- IMMUTABLE tags by default
- Default lifecycle policy (keeps 30 images)
- Tags validation

## Usage

```hcl
module "ecr" {
  source = "./aws/base_component/ecr"

  name        = "my-repo"
  kms_key_arn = module.kms.key_arn

  tags = {
    environment = "prod"
    owner       = "platform-team"
    project     = "my-app"
    cost_center = "CC-1234"
  }
}
```
