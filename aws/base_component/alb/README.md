# aws/base_component/alb

Opinionated Application Load Balancer module.

## Features

- Application Load Balancer
- Mandatory access logging to S3
- HTTPS listener support (optional)
- HTTP to HTTPS redirect (optional)
- Deletion protection enabled by default
- Tags validation

## Usage

### Simple ALB

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

### HTTPS with Redirect

```hcl
module "alb" {
  source = "./aws/base_component/alb"

  name                  = "my-alb"
  subnets               = ["subnet-12345", "subnet-67890"]
  security_groups       = ["sg-12345"]
  access_logs_bucket    = "my-logs-bucket"
  enable_https_listener = true
  certificate_arn       = "arn:aws:acm:us-east-1:123456789012:certificate/..."
  enable_http_redirect  = true

  tags = {
    environment = "prod"
    owner       = "platform-team"
    project     = "my-app"
    cost_center = "CC-1234"
  }
}
```
