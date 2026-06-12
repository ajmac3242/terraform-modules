# aws/base_component/security_group

## Purpose
Opinionated Security Group module. Consistent SG management with mandatory descriptions and no permissive default rules.

## Usage
```hcl
module "security_group" {
  source = "./aws/base_component/security_group"

  name        = "my-sg"
  description = "Allow inbound HTTPS"
  vpc_id      = module.vpc.vpc_id

  ingress_rules = [
    {
      description = "HTTPS from VPC"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = [module.vpc.cidr_block]
    }
  ]

  tags = {
    environment = "prod"
    owner       = "platform-team"
    project     = "standardization"
    cost_center = "12345"
  }
}
```

## Security
- **Least Privilege**: No default ingress or egress rules. All rules must be explicitly provided with a description.
- **Validation**: Enforces descriptions for all rules. Prevents `0.0.0.0/0` ingress by default (requires explicit override).

## Variables
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `name` | Name of the security group | `string` | n/a | yes |
| `description` | Description of the security group | `string` | n/a | yes |
| `vpc_id` | VPC ID where the security group will be created | `string` | n/a | yes |
| `ingress_rules` | List of ingress rule maps | `list(any)` | `[]` | no |
| `egress_rules` | List of egress rule maps | `list(any)` | `[]` | no |
| `tags` | Standard tags for all resources | `map(string)` | n/a | yes |

## Outputs
| Name | Description |
|------|-------------|
| `security_group_id` | The ID of the security group |
| `security_group_arn` | The ARN of the security group |
| `tags` | A map of tags assigned to the resource |

<!-- BEGIN_TF_DOCS -->


## Usage

```hcl
# See README.md for usage example
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_description"></a> [description](#input\_description) | Description of the security group | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of the security group | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to the resources | `map(string)` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The VPC ID where the security group will be created | `string` | n/a | yes |
| <a name="input_egress_rules"></a> [egress\_rules](#input\_egress\_rules) | List of egress rules | ```list(object({ from_port = number to_port = number protocol = string cidr_blocks = list(string) description = string }))``` | ```[ { "cidr_blocks": [ "0.0.0.0/0" ], "description": "Allow all outbound traffic", "from_port": 0, "protocol": "-1", "to_port": 0 } ]``` | no |
| <a name="input_ingress_rules"></a> [ingress\_rules](#input\_ingress\_rules) | List of ingress rules | ```list(object({ from_port = number to_port = number protocol = string cidr_blocks = list(string) description = string }))``` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_security_group_arn"></a> [security\_group\_arn](#output\_security\_group\_arn) | The ARN of the security group |
| <a name="output_security_group_id"></a> [security\_group\_id](#output\_security\_group\_id) | The ID of the security group |
| <a name="output_tags"></a> [tags](#output\_tags) | A map of tags assigned to the resource |

<!-- END_TF_DOCS -->