# aws/base_component/subnet

Standalone Subnet module. For custom network topologies where the standard VPC module is too rigid.

## Features

- `aws_subnet` with configurable CIDR and AZ
- `map_public_ip_on_launch` defaults to `false`
- Required tags enforced
- Automatic `Name` tag merging

## Usage

```hcl
module "subnet" {
  source = "./aws/base_component/subnet"

  name              = "custom-subnet-1"
  vpc_id            = module.vpc.vpc_id
  cidr_block        = "10.0.10.0/24"
  availability_zone = "us-east-1a"

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
| `vpc_id` | The VPC ID where the subnet will be created | `string` | n/a | yes |
| `cidr_block` | The CIDR block for the subnet | `string` | n/a | yes |
| `availability_zone` | The AZ for the subnet | `string` | n/a | yes |
| `map_public_ip_on_launch` | Whether instances get public IPs | `bool` | `false` | no |
| `name` | Name tag for the subnet | `string` | n/a | yes |
| `tags` | A map of tags to assign to the resources. Required keys: `environment`, `owner`, `project`, `cost_center`. | `map(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| `subnet_id` | The ID of the subnet |
| `subnet_arn` | The ARN of the subnet |
