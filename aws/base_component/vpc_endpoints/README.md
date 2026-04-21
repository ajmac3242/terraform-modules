# aws/base_component/vpc_endpoints

Opinionated VPC Endpoints module. Enables private access to AWS services without NAT gateways.

## Features

- Support for S3 and DynamoDB Gateway endpoints
- Support for Interface endpoints (e.g., kms, logs, execute-api)
- Automatic service name prefixing
- Required tags enforced

## Usage

```hcl
module "vpc_endpoints" {
  source = "./aws/base_component/vpc_endpoints"

  vpc_id = module.vpc.vpc_id
  region = "us-east-1"

  endpoints = {
    s3 = {
      service      = "s3"
      service_type = "Gateway"
    },
    kms = {
      service      = "kms"
      service_type = "Interface"
    }
  }

  subnet_ids         = module.vpc.private_subnet_ids
  security_group_ids = [module.endpoint_sg.security_group_id]

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
| `vpc_id` | The VPC ID | `string` | n/a | yes |
| `region` | AWS Region | `string` | n/a | yes |
| `endpoints` | Map of service configs | `map(object)` | n/a | yes |
| `subnet_ids` | Subnets for Interface endpoints | `list(string)` | `[]` | no |
| `route_table_ids` | Route tables for Gateway endpoints | `list(string)` | `[]` | no |
| `security_group_ids` | SGs for Interface endpoints | `list(string)` | `[]` | no |
| `tags` | A map of tags to assign to the resources. Required keys: `environment`, `owner`, `project`, `cost_center`. | `map(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| `endpoints` | A map of endpoint IDs |
