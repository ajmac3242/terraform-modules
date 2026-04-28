# aws/base_component/vpc

## Purpose
Foundational networking module. Required for Fargate, RDS, and secure Lambda placement. Enforces flow logs and private-by-default subnetting.

## Usage
```hcl
module "vpc" {
  source = "./aws/base_component/vpc"

  name        = "main-vpc"
  cidr_block  = "10.0.0.0/16"
  kms_key_arn = module.kms.key_arn

  tags = {
    environment = "prod"
    owner       = "platform-team"
    project     = "standardization"
    cost_center = "12345"
  }
}
```

## Security
- **Visibility**: VPC Flow Logs are enabled by default and sent to a CloudWatch Log Group encrypted with a CMK.
- **Segmentation**: Enforces public and private subnet separation across multiple AZs.
- **Hardening**: Default Security Group is hardened (all rules removed) via the `account_security` module if configured.

## Variables
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `name` | Name of the VPC | `string` | n/a | yes |
| `cidr_block` | CIDR block for the VPC | `string` | n/a | yes |
| `kms_key_arn` | KMS key ARN for VPC flow logs encryption | `string` | n/a | yes |
| `availability_zones` | List of availability zones | `list(string)` | `["us-east-1a", "us-east-1b"]` | no |
| `enable_nat_gateway` | Whether to enable NAT Gateways | `bool` | `true` | no |
| `tags` | Standard tags for all resources | `map(string)` | n/a | yes |

## Outputs
| Name | Description |
|------|-------------|
| `vpc_id` | The ID of the VPC |
| `vpc_arn` | The ARN of the VPC |
| `public_subnet_ids` | List of public subnet IDs |
| `private_subnet_ids` | List of private subnet IDs |
| `cidr_block` | The CIDR block of the VPC |
