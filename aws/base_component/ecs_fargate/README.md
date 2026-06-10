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
| `cpu` | Number of CPU units used by the task | `number` | `256` | no |
| `memory` | Amount of memory (in MiB) used by the task | `number` | `512` | no |
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

<!-- BEGIN_TF_DOCS -->


## Usage

```hcl
# See README.md for usage example
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_container_image"></a> [container\_image](#input\_container\_image) | The image used to start a container | `string` | n/a | yes |
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | The ARN of the KMS key for encryption of logs | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name for the ECS cluster and service | `string` | n/a | yes |
| <a name="input_private_subnet_ids"></a> [private\_subnet\_ids](#input\_private\_subnet\_ids) | A list of private subnet IDs for the Fargate service | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to the resources | `map(string)` | n/a | yes |
| <a name="input_container_port"></a> [container\_port](#input\_container\_port) | The port number on the container that is bound to the user-specified or automatically assigned host port | `number` | `80` | no |
| <a name="input_cpu"></a> [cpu](#input\_cpu) | Number of cpu units used by the task | `number` | `256` | no |
| <a name="input_desired_count"></a> [desired\_count](#input\_desired\_count) | Number of instances of the task definition to place and keep running | `number` | `1` | no |
| <a name="input_load_balancer_config"></a> [load\_balancer\_config](#input\_load\_balancer\_config) | Optional load balancer configuration for the ECS service | ```object({ target_group_arn = string container_name = string container_port = number })``` | `null` | no |
| <a name="input_memory"></a> [memory](#input\_memory) | Amount (in MiB) of memory used by the task | `number` | `512` | no |
| <a name="input_permissions_boundary_arn"></a> [permissions\_boundary\_arn](#input\_permissions\_boundary\_arn) | The ARN of the policy that is used to set the permissions boundary for the roles | `string` | `null` | no |
| <a name="input_platform_version"></a> [platform\_version](#input\_platform\_version) | The platform version on which to run your service | `string` | `"LATEST"` | no |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | A list of security group IDs to assign to the ECS service | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_arn"></a> [cluster\_arn](#output\_cluster\_arn) | The ARN of the ECS cluster |
| <a name="output_execution_role_arn"></a> [execution\_role\_arn](#output\_execution\_role\_arn) | The ARN of the execution IAM role |
| <a name="output_service_arn"></a> [service\_arn](#output\_service\_arn) | The ARN of the ECS service |
| <a name="output_tags"></a> [tags](#output\_tags) | A map of tags assigned to the resource |
| <a name="output_task_definition_arn"></a> [task\_definition\_arn](#output\_task\_definition\_arn) | The ARN of the task definition |
| <a name="output_task_role_arn"></a> [task\_role\_arn](#output\_task\_role\_arn) | The ARN of the task IAM role |

<!-- END_TF_DOCS -->