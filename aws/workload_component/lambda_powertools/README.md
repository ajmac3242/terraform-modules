# Standardized Lambda with Powertools

## Purpose
Standardizes serverless observability (logging, metrics, tracing) by composing the base Lambda module with AWS Lambda Powertools integration.

## Usage
```hcl
module "lambda_powertools" {
  source = "./aws/workload_component/lambda_powertools"

  function_name        = "my-observable-function"
  filename             = "lambda.zip"
  service_name         = "user-service"
  powertools_layer_arn = "arn:aws:lambda:us-east-1:017000801446:layer:AWSLambdaPowertoolsPythonV2:60"

  tags = {
    environment = "prod"
    owner       = "app-team"
    project     = "observability"
    cost_center = "1234"
  }
}
```

## Security
- Inherits security defaults from the base Lambda module (CMK encryption, X-Ray tracing).
- Mandatory CMK encryption for CloudWatch Logs.
- Least-privilege IAM execution role.

## Variables
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| function_name | The name of the Lambda function | string | n/a | yes |
| filename | Path to deployment package | string | n/a | yes |
| service_name | Service name for Powertools | string | n/a | yes |
| powertools_layer_arn | ARN of the Powertools layer | string | n/a | yes |
| log_level | Log level for Powertools | string | INFO | no |
| runtime | Lambda runtime | string | python3.11 | no |
| handler | Lambda handler | string | index.handler | no |
| kms_key_arn | ARN of the KMS key | string | null | no |
| vpc_config | VPC configuration | object | null | no |
| tags | Resource tags | map(string) | n/a | yes |

## Outputs
| Name | Description |
|------|-------------|
| function_arn | The ARN of the Lambda function |
| function_name | The name of the Lambda function |
| role_arn | The ARN of the execution role |
| log_group_name | The name of the Log Group |
| tags | Tags assigned to the resource |

<!-- BEGIN_TF_DOCS -->


## Usage

```hcl
# See README.md for usage example
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_filename"></a> [filename](#input\_filename) | The path to the function's deployment package within the local filesystem | `string` | n/a | yes |
| <a name="input_function_name"></a> [function\_name](#input\_function\_name) | The name of the Lambda function | `string` | n/a | yes |
| <a name="input_powertools_layer_arn"></a> [powertools\_layer\_arn](#input\_powertools\_layer\_arn) | The ARN of the Lambda Powertools layer | `string` | n/a | yes |
| <a name="input_service_name"></a> [service\_name](#input\_service\_name) | The name of the service for Powertools | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to the resources | `map(string)` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | Description of the Lambda function | `string` | `"Lambda with Powertools"` | no |
| <a name="input_handler"></a> [handler](#input\_handler) | The function entrypoint in your code | `string` | `"index.handler"` | no |
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | The ARN of the KMS key for encryption of environment variables and logs | `string` | `null` | no |
| <a name="input_log_level"></a> [log\_level](#input\_log\_level) | The log level for Powertools | `string` | `"INFO"` | no |
| <a name="input_runtime"></a> [runtime](#input\_runtime) | The runtime for the Lambda function | `string` | `"python3.11"` | no |
| <a name="input_vpc_config"></a> [vpc\_config](#input\_vpc\_config) | VPC configuration for the Lambda function | ```object({ subnet_ids = list(string) security_group_ids = list(string) })``` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_function_arn"></a> [function\_arn](#output\_function\_arn) | The ARN of the Lambda function |
| <a name="output_function_name"></a> [function\_name](#output\_function\_name) | The name of the Lambda function |
| <a name="output_log_group_name"></a> [log\_group\_name](#output\_log\_group\_name) | The name of the CloudWatch Log Group |
| <a name="output_role_arn"></a> [role\_arn](#output\_role\_arn) | The ARN of the execution role |
| <a name="output_tags"></a> [tags](#output\_tags) | A map of tags assigned to the resource |

<!-- END_TF_DOCS -->