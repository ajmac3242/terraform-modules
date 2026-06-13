# SageMaker Inference Base Module

## Purpose

This module provisions a secure and opinionated AWS SageMaker inference endpoint. It standardizes the deployment of models with mandatory VPC configuration, CMK encryption for at-rest data, and automated IAM role creation.

## Usage

```hcl
module "sagemaker_inference" {
  source = "./aws/base_component/sagemaker_inference"

  name            = "my-model-endpoint"
  container_image = "123456789012.dkr.ecr.us-east-1.amazonaws.com/my-inference-image:latest"
  kms_key_arn     = "arn:aws:kms:us-east-1:123456789012:key/my-key-id"

  vpc_config = {
    subnets            = ["subnet-12345", "subnet-67890"]
    security_group_ids = ["sg-12345"]
  }

  tags = {
    environment = "prod"
    owner       = "data-science"
    project     = "genai-platform"
    cost_center = "54321"
  }
}
```

## Security

- **Encryption**: SageMaker endpoint configurations require a mandatory Customer Managed Key (CMK) for encrypting models and data at rest.
- **Network Isolation**: All SageMaker models must be configured with VPC settings to ensure they are not exposed to the public internet.
- **Least Privilege**: If no `execution_role_arn` is provided, a dedicated IAM role is created with minimal necessary permissions for SageMaker execution.

## Variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | The name of the SageMaker inference resources | `string` | n/a | yes |
| execution_role_arn | The ARN of the IAM role for SageMaker execution | `string` | `null` | no |
| container_image | The container image to use for inference | `string` | n/a | yes |
| instance_type | The instance type to use for the inference endpoint | `string` | `"ml.t2.medium"` | no |
| kms_key_arn | The ARN of the KMS key for encryption | `string` | n/a | yes |
| vpc_config | VPC configuration for SageMaker resources | `object` | n/a | yes |
| tags | A map of tags to assign to the resources | `map(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| model_arn | The ARN of the SageMaker model |
| endpoint_configuration_arn | The ARN of the SageMaker endpoint configuration |
| endpoint_arn | The ARN of the SageMaker endpoint |
| endpoint_name | The name of the SageMaker endpoint |
| execution_role_arn | The ARN of the IAM role used by SageMaker |
| tags | A map of tags assigned to the resource |

<!-- BEGIN_TF_DOCS -->


## Usage

```hcl
# See README.md for usage example
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_container_image"></a> [container\_image](#input\_container\_image) | The container image to use for inference | `string` | n/a | yes |
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | The ARN of the KMS key for encryption. Format: ^arn:aws:kms:[a-z0-9-]+:[0-9]{12}:key/[a-z0-9-]+$ | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | The name of the SageMaker inference resources | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to the resources. Must include environment, owner, project, and cost\_center. | `map(string)` | n/a | yes |
| <a name="input_vpc_config"></a> [vpc\_config](#input\_vpc\_config) | VPC configuration for SageMaker resources | ```object({ security_group_ids = list(string) subnets = list(string) })``` | n/a | yes |
| <a name="input_execution_role_arn"></a> [execution\_role\_arn](#input\_execution\_role\_arn) | The ARN of the IAM role for SageMaker execution. If null, a role will be created. | `string` | `null` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | The instance type to use for the inference endpoint | `string` | `"ml.t2.medium"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_endpoint_arn"></a> [endpoint\_arn](#output\_endpoint\_arn) | The ARN of the SageMaker endpoint |
| <a name="output_endpoint_configuration_arn"></a> [endpoint\_configuration\_arn](#output\_endpoint\_configuration\_arn) | The ARN of the SageMaker endpoint configuration |
| <a name="output_endpoint_name"></a> [endpoint\_name](#output\_endpoint\_name) | The name of the SageMaker endpoint |
| <a name="output_execution_role_arn"></a> [execution\_role\_arn](#output\_execution\_role\_arn) | The ARN of the IAM role used by SageMaker |
| <a name="output_model_arn"></a> [model\_arn](#output\_model\_arn) | The ARN of the SageMaker model |
| <a name="output_tags"></a> [tags](#output\_tags) | A map of tags assigned to the resource |

<!-- END_TF_DOCS -->