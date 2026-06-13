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

<!-- BEGIN_TF_DOCS -->


## Usage

```hcl
# See README.md for usage example
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_logs_bucket"></a> [access\_logs\_bucket](#input\_access\_logs\_bucket) | The S3 bucket name to store the logs in | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | The name of the LB | `string` | n/a | yes |
| <a name="input_security_groups"></a> [security\_groups](#input\_security\_groups) | A list of security group IDs to assign to the LB | `list(string)` | n/a | yes |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | A list of subnet IDs to attach to the LB | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to the resources | `map(string)` | n/a | yes |
| <a name="input_access_logs_enabled"></a> [access\_logs\_enabled](#input\_access\_logs\_enabled) | Boolean to enable / disable access\_logs | `bool` | `true` | no |
| <a name="input_access_logs_prefix"></a> [access\_logs\_prefix](#input\_access\_logs\_prefix) | The S3 bucket prefix | `string` | `"alb"` | no |
| <a name="input_certificate_arn"></a> [certificate\_arn](#input\_certificate\_arn) | The ARN of the SSL certificate to use for the HTTPS listener | `string` | `null` | no |
| <a name="input_enable_deletion_protection"></a> [enable\_deletion\_protection](#input\_enable\_deletion\_protection) | If true, deletion of the load balancer will be disabled via the AWS API | `bool` | `true` | no |
| <a name="input_enable_http_redirect"></a> [enable\_http\_redirect](#input\_enable\_http\_redirect) | If true, an HTTP listener will be created that redirects to HTTPS | `bool` | `false` | no |
| <a name="input_enable_https_listener"></a> [enable\_https\_listener](#input\_enable\_https\_listener) | If true, an HTTPS listener will be created | `bool` | `false` | no |
| <a name="input_internal"></a> [internal](#input\_internal) | If true, the LB will be internal | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alb_arn"></a> [alb\_arn](#output\_alb\_arn) | The ARN of the ALB |
| <a name="output_alb_dns_name"></a> [alb\_dns\_name](#output\_alb\_dns\_name) | The DNS name of the load balancer |
| <a name="output_alb_id"></a> [alb\_id](#output\_alb\_id) | The ID of the ALB |
| <a name="output_alb_zone_id"></a> [alb\_zone\_id](#output\_alb\_zone\_id) | The canonical hosted zone ID of the load balancer |
| <a name="output_http_listener_arn"></a> [http\_listener\_arn](#output\_http\_listener\_arn) | The ARN of the HTTP listener |
| <a name="output_https_listener_arn"></a> [https\_listener\_arn](#output\_https\_listener\_arn) | The ARN of the HTTPS listener |
| <a name="output_security_group_id"></a> [security\_group\_id](#output\_security\_group\_id) | The ID of the primary security group associated with the ALB |
| <a name="output_tags"></a> [tags](#output\_tags) | A map of tags assigned to the resource |

<!-- END_TF_DOCS -->