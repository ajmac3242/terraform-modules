# aws/base_component/ecs_fargate

## Purpose
Opinionated ECS Fargate Service module. Common container compute pattern, enforcing VPC placement, Fargate launch type, and CMK encryption for logs.

## Usage
```hcl
module "ecs_fargate" {
  source = "./aws/base_component/ecs_fargate"

  name               = "my-service"
  container_image    = "my-ecr-repo-url:latest"
  private_subnet_ids = module.vpc.private_subnet_ids
  kms_key_arn        = module.kms.key_arn

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
- **Kernel Patching**: To address the "Copy.fail" (CVE-2026-31431) and "Dirty Frag" (CVE-2026-43284/43500) vulnerabilities, all deployments MUST use patched platform versions. Fargate platform versions `1.4.0` or later are required, specifically ensure the platform version maps to patched infrastructure released starting May 15, 2026.

## Variables
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `name` | Name for the ECS cluster and service | `string` | n/a | yes |
| `container_image` | Image to use for the container | `string` | n/a | yes |
| `private_subnet_ids` | A list of private subnet IDs for the Fargate service | `list(string)` | n/a | yes |
| `kms_key_arn` | KMS key ARN for log group encryption | `string` | n/a | yes |
| `cpu` | Number of CPU units used by the task (up to 32768 for 32vCPU) | `number` | `256` | no |
| `memory` | Amount of memory (in MiB) used by the task (up to 262144 for 32vCPU) | `number` | `512` | no |
| `desired_count` | Number of instances of the task definition to place and keep running | `number` | `1` | no |
| `platform_version` | The Fargate platform version on which to run your service | `string` | `"LATEST"` | no |
| `tags` | Standard tags for all resources | `map(string)` | n/a | yes |

## Outputs
| Name | Description |
|------|-------------|
| `cluster_arn` | The ARN of the ECS cluster |
| `service_arn` | The ARN of the ECS service |
| `task_definition_arn` | The ARN of the task definition |
| `task_role_arn` | The ARN of the task IAM role |
| `execution_role_arn` | The ARN of the execution IAM role |
| `tags` | A map of tags assigned to the resource |
