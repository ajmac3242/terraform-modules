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
| `tags` | A map of tags assigned to the VPC |

<!-- BEGIN_TF_DOCS -->


## Usage

```hcl
# See README.md for usage example
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | KMS key ARN for VPC Flow Logs encryption | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of the VPC | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to the resources | `map(string)` | n/a | yes |
| <a name="input_azs"></a> [azs](#input\_azs) | A list of availability zones names or ids in the region | `list(string)` | ```[ "us-east-1a", "us-east-1b", "us-east-1c" ]``` | no |
| <a name="input_cidr_block"></a> [cidr\_block](#input\_cidr\_block) | The CIDR block for the VPC | `string` | `"10.0.0.0/16"` | no |
| <a name="input_enable_nat_gateway"></a> [enable\_nat\_gateway](#input\_enable\_nat\_gateway) | Should be true if you want to provision NAT Gateways for each of your private networks | `bool` | `true` | no |
| <a name="input_private_subnets"></a> [private\_subnets](#input\_private\_subnets) | A list of private subnets inside the VPC | `list(string)` | ```[ "10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24" ]``` | no |
| <a name="input_public_subnets"></a> [public\_subnets](#input\_public\_subnets) | A list of public subnets inside the VPC | `list(string)` | ```[ "10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24" ]``` | no |
| <a name="input_single_nat_gateway"></a> [single\_nat\_gateway](#input\_single\_nat\_gateway) | Should be true if you want to provision a single shared NAT Gateway across all of your private networks | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_private_subnet_ids"></a> [private\_subnet\_ids](#output\_private\_subnet\_ids) | List of IDs of private subnets |
| <a name="output_public_subnet_ids"></a> [public\_subnet\_ids](#output\_public\_subnet\_ids) | List of IDs of public subnets |
| <a name="output_tags"></a> [tags](#output\_tags) | A map of tags assigned to the VPC |
| <a name="output_vpc_arn"></a> [vpc\_arn](#output\_vpc\_arn) | The ARN of the VPC |
| <a name="output_vpc_cidr_block"></a> [vpc\_cidr\_block](#output\_vpc\_cidr\_block) | The CIDR block of the VPC |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | The ID of the VPC |

<!-- END_TF_DOCS -->