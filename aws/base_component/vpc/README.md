# aws/base_component/vpc

Opinionated VPC module. Foundational networking module that enforces flow logs and private-by-default subnetting.

## Features

- VPC with configurable CIDR block
- Public and Private subnets across multiple AZs
- NAT Gateway (configurable: one per AZ, single, or none)
- VPC Flow Logs enabled and sent to CloudWatch (encrypted with CMK)
- Required tags enforced on VPC and all subnets

## Usage

```hcl
module "vpc" {
  source = "./aws/base_component/vpc"

  name        = "main-vpc"
  cidr_block  = "10.0.0.0/16"
  kms_key_arn = "arn:aws:kms:us-east-1:123456789012:key/..."

  tags = {
    environment = "prod"
    owner       = "platform-team"
    project     = "infrastructure"
    cost_center = "CC-1234"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `name` | Name of the VPC | `string` | n/a | yes |
| `cidr_block` | The CIDR block for the VPC | `string` | `"10.0.0.0/16"` | no |
| `public_subnets` | A list of public subnets inside the VPC | `list(string)` | `["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]` | no |
| `private_subnets` | A list of private subnets inside the VPC | `list(string)` | `["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]` | no |
| `azs` | A list of availability zones names or ids in the region | `list(string)` | `["us-east-1a", "us-east-1b", "us-east-1c"]` | no |
| `enable_nat_gateway` | Should be true if you want to provision NAT Gateways for each of your private networks | `bool` | `true` | no |
| `single_nat_gateway` | Should be true if you want to provision a single shared NAT Gateway across all of your private networks | `bool` | `true` | no |
| `kms_key_arn` | KMS key ARN for VPC Flow Logs encryption | `string` | n/a | yes |
| `tags` | A map of tags to assign to the resources. Required keys: `environment`, `owner`, `project`, `cost_center`. | `map(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| `vpc_id` | The ID of the VPC |
| `private_subnet_ids` | List of IDs of private subnets |
| `public_subnet_ids` | List of IDs of public subnets |
| `vpc_cidr_block` | The CIDR block of the VPC |
