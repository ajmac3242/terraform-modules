# aws/base_component/asg

## Purpose
Opinionated Auto Scaling Group module. Secure EC2 auto-scaling with mandatory EBS encryption and monitoring.

## Usage
```hcl
module "asg" {
  source = "./aws/base_component/asg"

  name          = "my-asg"
  image_id      = "ami-12345678"
  instance_type = "t3.medium"
  vpc_zone_identifier = module.vpc.private_subnet_ids
  kms_key_arn   = module.kms.key_arn

  tags = {
    environment = "prod"
    owner       = "platform-team"
    project     = "standardization"
    cost_center = "12345"
  }
}
```

## Security
- **Encryption**: Enforces EBS encryption using a Customer Managed Key (CMK).
- **Monitoring**: Detailed monitoring is enabled by default.
- **IMDS**: Enforces IMDSv2 with a hop limit of 1.

## Variables
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `name` | Name of the ASG and Launch Template | `string` | n/a | yes |
| `image_id` | AMI ID to use for the instances | `string` | n/a | yes |
| `instance_type` | Instance type to use | `string` | n/a | yes |
| `vpc_zone_identifier` | List of subnet IDs to launch instances in | `list(string)` | n/a | yes |
| `kms_key_arn` | KMS key ARN for EBS encryption | `string` | n/a | yes |
| `min_size` | Minimum size of the ASG | `number` | `1` | no |
| `max_size` | Maximum size of the ASG | `number` | `3` | no |
| `desired_capacity` | Desired capacity of the ASG | `number` | `1` | no |
| `tags` | Standard tags for all resources | `map(string)` | n/a | yes |

## Outputs
| Name | Description |
|------|-------------|
| `asg_arn` | The ARN of the Auto Scaling Group |
| `asg_id` | The ID of the Auto Scaling Group |
| `launch_template_arn` | The ARN of the Launch Template |
| `launch_template_id` | The ID of the Launch Template |
| `tags` | A map of tags assigned to the resources |
