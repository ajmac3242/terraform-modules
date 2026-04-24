# aws/base_component/efs

Opinionated EFS File System module.

## Features

- EFS File System
- Mandatory encryption with CMK
- Mandatory Backup Policy (ENABLED)
- Elastic throughput mode by default
- Tags validation

## Usage

```hcl
module "efs" {
  source = "./aws/base_component/efs"

  name       = "my-efs"
  kms_key_id = module.kms.key_arn

  tags = {
    environment = "prod"
    owner       = "platform-team"
    project     = "my-app"
    cost_center = "CC-1234"
  }
}
```
