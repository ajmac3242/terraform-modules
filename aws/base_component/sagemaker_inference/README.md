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
