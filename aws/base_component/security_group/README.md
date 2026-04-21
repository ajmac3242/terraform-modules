# aws/base_component/security_group

Opinionated Security Group module. Consistent SG management with mandatory descriptions and no `0.0.0.0/0` defaults for ingress.

## Features

- `aws_security_group` with mandatory `description`
- No default ingress rules (must be explicitly provided)
- Validation: No `0.0.0.0/0` in ingress rules for security enforcement
- Required tags enforced

## Usage

```hcl
module "security_group" {
  source = "./aws/base_component/security_group"

  name        = "app-sg"
  description = "Security group for my application"
  vpc_id      = module.vpc.vpc_id

  ingress_rules = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/8"]
      description = "Allow HTTP from VPC"
    }
  ]

  tags = {
    environment = "prod"
    owner       = "platform-team"
    project     = "my-app"
    cost_center = "CC-1234"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `name` | Name of the security group | `string` | n/a | yes |
| `description` | Description of the security group | `string` | n/a | yes |
| `vpc_id` | The VPC ID where the security group will be created | `string` | n/a | yes |
| `ingress_rules` | List of ingress rules | `list(object)` | `[]` | no |
| `egress_rules` | List of egress rules | `list(object)` | See `variables.tf` | no |
| `tags` | A map of tags to assign to the resources. Required keys: `environment`, `owner`, `project`, `cost_center`. | `map(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| `security_group_id` | The ID of the security group |
| `security_group_arn` | The ARN of the security group |
