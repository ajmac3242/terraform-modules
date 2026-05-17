# aws/base_component/alb

## Purpose
Opinionated Application Load Balancer module. Foundational ingress and traffic-routing module for ECS and future application patterns. Standardizes TLS posture, access logging, and safe security-group defaults.

## Usage
```hcl
module "alb" {
  source = "./aws/base_component/alb"

  name    = "my-alb"
  vpc_id  = module.vpc.vpc_id
  subnets = module.vpc.public_subnet_ids

  tags = {
    environment = "prod"
    owner       = "platform-team"
    project     = "standardization"
    cost_center = "12345"
  }
}
```

## Security
- **Encryption**: HTTPS listeners use modern TLS policies (`ELBSecurityPolicy-TLS13-1-2-2021-06`).
- **Access Logging**: Access logging is enabled by default to an S3 bucket.
- **Exposure Control**: Supports HTTP-to-HTTPS redirection by default. Deletion protection is enabled by default.

## Variables
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `name` | Name of the ALB | `string` | n/a | yes |
| `vpc_id` | VPC ID where the ALB and Security Group will be created | `string` | n/a | yes |
| `subnets` | List of subnet IDs to launch the ALB in | `list(string)` | n/a | yes |
| `internal` | Whether the ALB is internal or public-facing | `bool` | `false` | no |
| `enable_deletion_protection` | If true, deletion of the load balancer will be disabled via the AWS API | `bool` | `true` | no |
| `access_logs_bucket` | S3 bucket name for access logs. Required if enable_access_logs is true. | `string` | `null` | no |
| `enable_access_logs` | Enable ALB access logs | `bool` | `true` | no |
| `tags` | Standard tags for all resources | `map(string)` | n/a | yes |

## Outputs
| Name | Description |
|------|-------------|
| `alb_arn` | The ARN of the ALB |
| `alb_id` | The ID of the ALB |
| `alb_dns_name` | The DNS name of the ALB |
| `alb_zone_id` | The canonical hosted zone ID of the ALB |
| `security_group_id` | The ID of the default security group created for the ALB |
| `tags` | A map of tags assigned to the resource |
