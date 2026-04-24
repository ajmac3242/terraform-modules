# aws/base_component/asg

Opinionated Auto Scaling Group module.

## Features

- Auto Scaling Group with Launch Template
- Mandatory EBS encryption with CMK
- Tags propagation at launch
- Monitoring enabled by default

## Usage

```hcl
module "asg" {
  source = "./aws/base_component/asg"

  name                = "my-asg"
  image_id            = "ami-12345678"
  vpc_zone_identifier = ["subnet-12345", "subnet-67890"]
  kms_key_arn         = module.kms.key_arn

  tags = {
    environment = "prod"
    owner       = "platform-team"
    project     = "my-app"
    cost_center = "CC-1234"
  }
}
```
