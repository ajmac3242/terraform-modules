# VPC Lattice Base Module

## Purpose
This module provisions an opinionated VPC Lattice service network and service, handles VPC associations, and enforces security defaults like CMK-encrypted access logs and least-privilege auth policies.

## Usage
```hcl
module "vpc_lattice" {
  source = "./aws/base_component/vpc_lattice"

  name        = "my-app-network"
  vpc_id      = "vpc-12345678"
  kms_key_arn = "arn:aws:kms:us-east-1:123456789012:key/mrk-1234"

  tags = {
    environment = "prod"
    owner       = "platform-team"
    project     = "infrastructure"
    cost_center = "1234"
  }
}
```

## Security
- **CMK Encryption**: Access logs are sent to a CloudWatch Log Group encrypted with a customer-managed key (CMK).
- **Auth Policy**: A default auth policy is applied to the service network to enforce secure invocation.
- **Least Privilege**: The module encourages the use of `AWS_IAM` auth type for robust service-to-service authentication.

## Variables
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | The name of the VPC Lattice service network and service | `string` | n/a | yes |
| auth_type | The auth type for the service network (NONE, AWS_IAM) | `string` | `AWS_IAM` | no |
| vpc_id | The VPC ID to associate with the service network | `string` | n/a | yes |
| kms_key_arn | The ARN of the KMS CMK to use for encrypting access logs | `string` | n/a | yes |
| tags | A map of tags to assign to the resources | `map(string)` | n/a | yes |

## Outputs
| Name | Description |
|------|-------------|
| service_network_id | The ID of the VPC Lattice service network |
| service_network_arn | The ARN of the VPC Lattice service network |
| service_id | The ID of the VPC Lattice service |
| service_arn | The ARN of the VPC Lattice service |
| log_group_arn | The ARN of the CloudWatch Log Group for access logs |
| tags | The tags assigned to the resources |

<!-- BEGIN_TF_DOCS -->


## Usage

```hcl
# See README.md for usage example
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | The ARN of the KMS CMK to use for encrypting access logs. Standardized naming per memory. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | The name of the VPC Lattice service network and service | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to the resources | `map(string)` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The VPC ID to associate with the service network | `string` | n/a | yes |
| <a name="input_auth_type"></a> [auth\_type](#input\_auth\_type) | The auth type for the service network. Valid values are NONE and AWS\_IAM. | `string` | `"AWS_IAM"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_log_group_arn"></a> [log\_group\_arn](#output\_log\_group\_arn) | The ARN of the CloudWatch Log Group for VPC Lattice access logs |
| <a name="output_service_arn"></a> [service\_arn](#output\_service\_arn) | The ARN of the VPC Lattice service |
| <a name="output_service_id"></a> [service\_id](#output\_service\_id) | The ID of the VPC Lattice service |
| <a name="output_service_network_arn"></a> [service\_network\_arn](#output\_service\_network\_arn) | The ARN of the VPC Lattice service network |
| <a name="output_service_network_id"></a> [service\_network\_id](#output\_service\_network\_id) | The ID of the VPC Lattice service network |
| <a name="output_tags"></a> [tags](#output\_tags) | The tags assigned to the resources |

<!-- END_TF_DOCS -->