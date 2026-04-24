# aws/base_component/alb

Opinionated Application Load Balancer module.

## Features

- Application Load Balancer
- Mandatory access logging to S3
- Tags validation

## Usage

```hcl
module "alb" {
  source = "./aws/base_component/alb"

  name               = "my-alb"
  subnets            = ["subnet-12345", "subnet-67890"]
  security_groups    = ["sg-12345"]
  access_logs_bucket = "my-logs-bucket"

  tags = {
    environment = "prod"
    owner       = "platform-team"
    project     = "my-app"
    cost_center = "CC-1234"
  }
}
```
