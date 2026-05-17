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
