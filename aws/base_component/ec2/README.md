# aws/base_component/ec2

Opinionated EC2 Instance module.

## Features

- EC2 Instance
- Mandatory root EBS encryption with CMK
- Detailed monitoring enabled
- Tags validation

## Usage

```hcl
module "ec2" {
  source = "./aws/base_component/ec2"

  name        = "my-instance"
  ami         = "ami-12345678"
  subnet_id   = "subnet-12345"
  kms_key_arn = module.kms.key_arn

  tags = {
    environment = "prod"
    owner       = "platform-team"
    project     = "my-app"
    cost_center = "CC-1234"
  }
}
```
