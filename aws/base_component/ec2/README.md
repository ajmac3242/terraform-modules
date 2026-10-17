# aws/base_component/ec2

## Purpose
Opinionated EC2 Instance module. Secure single-instance compute with mandatory EBS encryption and detailed monitoring.

## Usage
```hcl
module "ec2" {
  source = "./aws/base_component/ec2"

  name          = "my-instance"
  ami           = "ami-12345678"
  instance_type = "t3.medium"
  subnet_id     = module.vpc.private_subnet_ids[0]
  kms_key_arn   = module.kms.key_arn

  tags = {
    environment = "prod"
    owner       = "platform-team"
    project     = "standardization"
    cost_center = "12345"
  }
}
```

## Security
- **Encryption**: Root and additional block devices are encrypted using a Customer Managed Key (CMK).
- **Monitoring**: Detailed monitoring is enabled to provide high-frequency visibility.
- **IMDS**: Enforces IMDSv2 (tokens required) and restricts hop limit to 1.
- **Kernel Patching**: To address the "Copy.fail" (CVE-2026-31431) and "Dirty Frag" (CVE-2026-43284/43500) vulnerabilities, all deployments MUST use patched platform versions:
  - Amazon Linux 2023: AL2023.4.20260515.0 or later
  - Bottlerocket: v1.19.2 or later
  - Dynamic AMI selection via SSM parameters is recommended to ensure rapid patching.

## Variables
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `name` | Name tag for the EC2 instance | `string` | n/a | yes |
| `ami` | AMI ID to use for the instance | `string` | n/a | yes |
| `instance_type` | Instance type to use | `string` | n/a | yes |
| `subnet_id` | VPC Subnet ID to launch in | `string` | n/a | yes |
| `kms_key_arn` | KMS key ARN for EBS encryption | `string` | n/a | yes |
| `vpc_security_group_ids` | List of security group IDs to associate with | `list(string)` | `[]` | no |
| `tags` | Standard tags for all resources | `map(string)` | n/a | yes |

## Outputs
| Name | Description |
|------|-------------|
| `instance_arn` | The ARN of the EC2 instance |
| `instance_id` | The ID of the EC2 instance |
| `private_ip` | The private IP address of the instance |
| `tags` | A map of tags assigned to the resource |

<!-- BEGIN_TF_DOCS -->


## Usage

```hcl
# See README.md for usage example
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ami"></a> [ami](#input\_ami) | The AMI to use for the instance | `string` | n/a | yes |
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | The ARN of the KMS key for EBS encryption | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | The name of the EC2 instance | `string` | n/a | yes |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | The VPC Subnet ID to launch in | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to the resources | `map(string)` | n/a | yes |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | The instance type to use | `string` | `"t3.micro"` | no |
| <a name="input_user_data"></a> [user\_data](#input\_user\_data) | The user data to provide when launching the instance | `string` | `null` | no |
| <a name="input_vpc_security_group_ids"></a> [vpc\_security\_group\_ids](#input\_vpc\_security\_group\_ids) | A list of security group IDs to associate with | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_instance_arn"></a> [instance\_arn](#output\_instance\_arn) | The ARN of the instance |
| <a name="output_instance_id"></a> [instance\_id](#output\_instance\_id) | The ID of the instance |
| <a name="output_private_ip"></a> [private\_ip](#output\_private\_ip) | The private IP address assigned to the instance |
| <a name="output_tags"></a> [tags](#output\_tags) | A map of tags assigned to the resource |

<!-- END_TF_DOCS -->