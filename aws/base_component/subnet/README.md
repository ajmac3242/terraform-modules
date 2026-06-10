# aws/base_component/subnet

## Purpose
Standalone Subnet module for custom network topologies where the standard VPC module is too rigid.

## Usage
```hcl
module "custom_subnet" {
  source = "./aws/base_component/subnet"

  vpc_id            = module.vpc.vpc_id
  cidr_block        = "10.0.10.0/24"
  availability_zone = "us-east-1a"
  name              = "custom-private-subnet"

  tags = {
    environment = "prod"
    owner       = "platform-team"
    project     = "standardization"
    cost_center = "12345"
  }
}
```

## Security
- **Isolation**: `map_public_ip_on_launch` defaults to `false` to ensure instances are private by default.
- **Organization**: Mandatory tagging for resource discovery and billing.

## Variables
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `vpc_id` | VPC ID where the subnet will be created | `string` | n/a | yes |
| `cidr_block` | CIDR block for the subnet | `string` | n/a | yes |
| `availability_zone` | AZ where the subnet will reside | `string` | n/a | yes |
| `name` | Name tag for the subnet | `string` | n/a | yes |
| `map_public_ip_on_launch` | Whether to map public IPs on launch | `bool` | `false` | no |
| `tags` | Standard tags for all resources | `map(string)` | n/a | yes |

## Outputs
| Name | Description |
|------|-------------|
| `subnet_id` | The ID of the subnet |
| `subnet_arn` | The ARN of the subnet |
| `tags` | A map of tags assigned to the resource |

<!-- BEGIN_TF_DOCS -->


## Usage

```hcl
# See README.md for usage example
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_availability_zone"></a> [availability\_zone](#input\_availability\_zone) | The AZ for the subnet | `string` | n/a | yes |
| <a name="input_cidr_block"></a> [cidr\_block](#input\_cidr\_block) | The CIDR block for the subnet | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name tag for the subnet | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to the resources | `map(string)` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The VPC ID where the subnet will be created | `string` | n/a | yes |
| <a name="input_map_public_ip_on_launch"></a> [map\_public\_ip\_on\_launch](#input\_map\_public\_ip\_on\_launch) | Indicates whether instances launched into the subnet should be assigned a public IP address | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_subnet_arn"></a> [subnet\_arn](#output\_subnet\_arn) | The ARN of the subnet |
| <a name="output_subnet_id"></a> [subnet\_id](#output\_subnet\_id) | The ID of the subnet |
| <a name="output_tags"></a> [tags](#output\_tags) | A map of tags assigned to the resource |

<!-- END_TF_DOCS -->