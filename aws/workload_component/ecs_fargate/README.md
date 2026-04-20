# aws/workload_component/ecs_fargate

ECS Fargate Service pattern. Enforces VPC placement, Fargate launch type, and CMK encryption for logs.

## Features

- `aws_ecs_cluster` and `aws_ecs_service`
- Task definition with Fargate compatibility
- Placed in VPC private subnets
- Log group with KMS encryption (mandatory CMK)
- Task execution role and Task role via `aws/base_component/iam`
- Required tags enforced

## Usage

```hcl
module "ecs_fargate" {
  source = "./aws/workload_component/ecs_fargate"

  name               = "my-service"
  private_subnet_ids = module.vpc.private_subnet_ids
  container_image    = "nginx:latest"
  kms_key_arn        = module.kms.key_arn

  tags = {
    environment = "prod"
    owner       = "platform-team"
    project     = "my-app"
    cost_center = "CC-1234"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `name` | Name for the ECS cluster and service | `string` | n/a | yes |
| `private_subnet_ids` | A list of private subnet IDs | `list(string)` | n/a | yes |
| `container_image` | The image used to start a container | `string` | n/a | yes |
| `container_port` | The port number on the container | `number` | `80` | no |
| `cpu` | Number of cpu units used by the task | `number` | `256` | no |
| `memory` | Amount (in MiB) of memory used by the task | `number` | `512` | no |
| `desired_count` | Number of instances of the task | `number` | `1` | no |
| `kms_key_arn` | The ARN of the KMS key for logs | `string` | n/a | yes |
| `tags` | A map of tags to assign to the resources. Required keys: `environment`, `owner`, `project`, `cost_center`. | `map(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| `cluster_arn` | The ARN of the ECS cluster |
| `service_arn` | The ARN of the ECS service |
| `task_definition_arn` | The ARN of the task definition |
