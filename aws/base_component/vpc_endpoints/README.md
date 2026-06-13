# aws/base_component/vpc_endpoints

## Purpose
Opinionated VPC Endpoints module. Enables private access to AWS services without NAT gateways, improving security and reducing costs.

## Usage
```hcl
module "vpc_endpoints" {
  source = "./aws/base_component/vpc_endpoints"

  vpc_id             = module.vpc.vpc_id
  subnet_ids         = module.vpc.private_subnet_ids
  security_group_ids = [module.security_group.id]

  services = ["kms", "logs", "ssm"]

  tags = {
    environment = "prod"
    owner       = "platform-team"
    project     = "standardization"
    cost_center = "12345"
  }
}
```

## Security
- **Isolation**: Traffic to AWS services remains within the AWS network.
- **Access**: Security groups for Interface endpoints are scoped to allow access from within the VPC CIDR. Supports Endpoint Policies for granular control.

## Variables
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `vpc_id` | VPC ID where endpoints will be created | `string` | n/a | yes |
| `subnet_ids` | List of subnet IDs for Interface endpoints | `list(string)` | `[]` | no |
| `security_group_ids` | List of security group IDs for Interface endpoints | `list(string)` | `[]` | no |
| `services` | List of Interface endpoint services to enable | `list(string)` | `[]` | no |
| `enable_s3_endpoint` | Whether to enable the S3 Gateway endpoint | `bool` | `true` | no |
| `enable_dynamodb_endpoint` | Whether to enable the DynamoDB Gateway endpoint | `bool` | `true` | no |
| `tags` | Standard tags for all resources | `map(string)` | n/a | yes |

## Outputs
| Name | Description |
|------|-------------|
| `interface_endpoint_ids` | Map of Interface endpoint IDs |
| `s3_endpoint_id` | The ID of the S3 Gateway endpoint |
| `dynamodb_endpoint_id` | The ID of the DynamoDB Gateway endpoint |
| `tags` | A map of tags assigned to the resources |

<!-- BEGIN_TF_DOCS -->


## Usage

```hcl
# See README.md for usage example
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_endpoints"></a> [endpoints](#input\_endpoints) | A map of endpoint configurations | ```map(object({ service = string service_type = string # Interface or Gateway private_dns_enabled = optional(bool, true) }))``` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The AWS region | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to the resources | `map(string)` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The ID of the VPC where endpoints will be created | `string` | n/a | yes |
| <a name="input_route_table_ids"></a> [route\_table\_ids](#input\_route\_table\_ids) | A list of route table IDs for gateway endpoints | `list(string)` | `[]` | no |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | A list of security group IDs for interface endpoints | `list(string)` | `[]` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | A list of subnet IDs for interface endpoints | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_endpoint_arns"></a> [endpoint\_arns](#output\_endpoint\_arns) | A map of endpoint ARNs |
| <a name="output_endpoints"></a> [endpoints](#output\_endpoints) | A map of endpoint IDs |
| <a name="output_tags"></a> [tags](#output\_tags) | A map of tags assigned to the resources |

<!-- END_TF_DOCS -->