# aws/workload_component/alb_ecs_fargate

Composed workload module for ALB + ECS Fargate service.

## Features

- Creates an Application Load Balancer (optional) using the opinionated base module.
- Creates an ECS Fargate Cluster and Service using the opinionated base module.
- Automatically wires the ALB Target Group and Listener Rule to the ECS Service.
- Supports HTTPS with ACM certificates and HTTP-to-HTTPS redirection.
- Enforces mandatory access logging for ALB and CMK encryption for ECS logs.
- Enforces organization-standard tagging.

## Usage

```hcl
module "app_service" {
  source = "./aws/workload_component/alb_ecs_fargate"

  name               = "web-app"
  vpc_id             = module.vpc.vpc_id
  public_subnet_ids  = module.vpc.public_subnet_ids
  private_subnet_ids = module.vpc.private_subnet_ids

  container_image = "nginx:latest"
  container_port  = 80

  kms_key_arn        = module.kms.key_arn
  access_logs_bucket = module.s3_logs.bucket_id

  tags = {
    environment = "prod"
    owner       = "app-team"
    project     = "portal"
    cost_center = "CC-1234"
  }
}
```

## Security

- ALB access logs are enabled by default.
- ECS logs are encrypted with a Customer Managed Key (CMK).
- ECS tasks are placed in private subnets with no public IP.
- HTTPS is supported with TLS 1.3 as the minimum version (via base module).
