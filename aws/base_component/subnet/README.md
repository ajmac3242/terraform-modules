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
