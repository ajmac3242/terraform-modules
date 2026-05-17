# aws/base_component/ec2

## Purpose
Opinionated EC2 Instance module. Secure single-instance compute with mandatory EBS encryption and detailed monitoring.

## Usage
```hcl
module "ec2" {
  source = "./aws/base_component/ec2"

  name          = "my-instance"
  ami           = "ami-12345678"
  instance_type = "t3.medium"
  subnet_id     = module.vpc.private_subnet_ids[0]
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
- **Encryption**: Root and additional block devices are encrypted using a Customer Managed Key (CMK).
- **Monitoring**: Detailed monitoring is enabled to provide high-frequency visibility.
- **IMDS**: Enforces IMDSv2 (tokens required) and restricts hop limit to 1.

## Variables
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `name` | Name tag for the EC2 instance | `string` | n/a | yes |
| `ami` | AMI ID to use for the instance | `string` | n/a | yes |
| `instance_type` | Instance type to use | `string` | n/a | yes |
| `subnet_id` | VPC Subnet ID to launch in | `string` | n/a | yes |
| `kms_key_arn` | KMS key ARN for EBS encryption | `string` | n/a | yes |
| `vpc_security_group_ids` | List of security group IDs to associate with | `list(string)` | `[]` | no |
| `tags` | Standard tags for all resources | `map(string)` | n/a | yes |

## Outputs
| Name | Description |
|------|-------------|
| `instance_arn` | The ARN of the EC2 instance |
| `instance_id` | The ID of the EC2 instance |
| `private_ip` | The private IP address of the instance |
| `tags` | A map of tags assigned to the resource |
