# aws/base_component/ecs_fargate

## Purpose
Opinionated ECS Fargate Service module. Common container compute pattern, enforcing VPC placement, Fargate launch type, and CMK encryption for logs.

## Usage
```hcl
module "ecs_fargate" {
  source = "./aws/base_component/ecs_fargate"

  cluster_name    = "my-cluster"
  service_name    = "my-service"
  container_image = "my-ecr-repo-url:latest"
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.private_subnet_ids
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
- **Encryption**: CloudWatch log groups are encrypted using a Customer Managed Key (CMK).
- **Network**: Service is placed in private VPC subnets with no direct public access.
- **IAM**: Task and execution roles are scoped to least-privilege using the base IAM module.

## Variables
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `cluster_name` | Name of the ECS cluster | `string` | n/a | yes |
| `service_name` | Name of the ECS service | `string` | n/a | yes |
| `container_image` | Image to use for the container | `string` | n/a | yes |
| `vpc_id` | VPC ID where the service will be deployed | `string` | n/a | yes |
| `subnet_ids` | List of subnet IDs for the service task placement | `list(string)` | n/a | yes |
| `kms_key_arn` | KMS key ARN for log group encryption | `string` | n/a | yes |
| `cpu` | Number of CPU units used by the task | `number` | `256` | no |
| `memory` | Amount of memory (in MiB) used by the task | `number` | `512` | no |
| `desired_count` | Number of instances of the task definition to place and keep running | `number` | `1` | no |
| `tags` | Standard tags for all resources | `map(string)` | n/a | yes |

## Outputs
| Name | Description |
|------|-------------|
| `cluster_arn` | The ARN of the ECS cluster |
| `service_arn` | The ARN of the ECS service |
| `task_definition_arn` | The ARN of the task definition |
| `task_role_arn` | The ARN of the task IAM role |
| `execution_role_arn` | The ARN of the execution IAM role |
