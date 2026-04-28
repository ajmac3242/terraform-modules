# aws/workload_component/alb_ecs_fargate

## Purpose
ALB + ECS Fargate service pattern. One of the most common production application deployment patterns, composing ingress, target groups, ECS service, and networking into a secure default.

## Usage
```hcl
module "app" {
  source = "./aws/workload_component/alb_ecs_fargate"

  name            = "my-app"
  vpc_id          = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnet_ids
  public_subnets  = module.vpc.public_subnet_ids
  container_image = "my-ecr-repo-url:latest"
  certificate_arn = module.acm.certificate_arn
  kms_key_arn     = module.kms.key_arn

  tags = {
    environment = "prod"
    owner       = "platform-team"
    project     = "standardization"
    cost_center = "12345"
  }
}
```

## Security
- **Encryption**: Enforces HTTPS for all ingress traffic. CloudWatch logs are encrypted using a CMK.
- **Inbound Control**: ALB is protected by optional WAF. Only HTTPS traffic is permitted; HTTP is redirected.
- **Isolation**: ECS tasks are placed in private subnets with no direct internet ingress.

## Variables
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `name` | Name of the service and related resources | `string` | n/a | yes |
| `vpc_id` | VPC ID where resources will be deployed | `string` | n/a | yes |
| `private_subnets` | List of private subnet IDs for ECS tasks | `list(string)` | n/a | yes |
| `public_subnets` | List of public subnet IDs for the ALB | `list(string)` | n/a | yes |
| `container_image` | Image to use for the container | `string` | n/a | yes |
| `container_port` | Port the container listens on | `number` | `80` | no |
| `certificate_arn` | ACM certificate ARN for the HTTPS listener | `string` | n/a | yes |
| `kms_key_arn` | KMS key ARN for log group encryption | `string` | n/a | yes |
| `tags` | Standard tags for all resources | `map(string)` | n/a | yes |

## Outputs
| Name | Description |
|------|-------------|
| `alb_dns_name` | The DNS name of the ALB |
| `service_arn` | The ARN of the ECS service |
| `target_group_arn` | The ARN of the ALB target group |
| `listener_arn` | The ARN of the ALB listener |
