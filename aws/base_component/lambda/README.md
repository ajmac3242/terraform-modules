# aws/base_component/lambda

## Purpose
Opinionated Lambda function module. Primary compute primitive, centralizing execution role creation, VPC config, CMK env var encryption, and CloudWatch log groups.

## Usage
```hcl
module "lambda" {
  source = "./aws/base_component/lambda"

  function_name = "my-function"
  runtime       = "nodejs18.x"
  handler       = "index.handler"
  filename      = "function.zip"

  vpc_config = {
    subnet_ids         = module.vpc.private_subnet_ids
    security_group_ids = [module.security_group.id]
  }

  tags = {
    environment = "prod"
    owner       = "platform-team"
    project     = "standardization"
    cost_center = "12345"
  }
}

# Example: Mounting an S3 bucket
module "lambda_with_s3" {
  source = "./aws/base_component/lambda"

  function_name = "my-s3-function"
  runtime       = "python3.11"
  handler       = "index.handler"
  filename      = "function.zip"

  file_system_config = [
    {
      arn              = "arn:aws:s3:::my-bucket"
      local_mount_path = "/mnt/s3"
    }
  ]

  tags = var.tags
}
```

## Security
- **Encryption**: Environment variables are encrypted using a Customer Managed Key (CMK). CloudWatch logs are also encrypted.
- **Tracing**: X-Ray `tracing_config` is set to `Active` by default.
- **Network**: Supports VPC placement for access to private resources.
- **IAM**: Execution roles are scoped to least-privilege.

## Variables
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `function_name` | Name of the Lambda function | `string` | n/a | yes |
| `runtime` | Lambda runtime | `string` | n/a | yes |
| `handler` | Lambda handler | `string` | n/a | yes |
| `filename` | Path to the function deployment package | `string` | `null` | no |
| `vpc_config` | VPC configuration for the function | `object` | `null` | no |
| `file_system_config` | Connection settings for an EFS or S3 file system. Supports mounting a single S3 Files access point (AWS Provider 6.45.0+) or EFS access point. | `list(object)` | `[]` | no |
| `kms_key_arn` | KMS key ARN for environment variable and log encryption | `string` | `null` | no |
| `memory_size` | Amount of memory in MB your Lambda Function can use at runtime | `number` | `128` | no |
| `timeout` | Amount of time your Lambda Function has to run in seconds | `number` | `3` | no |
| `tags` | Standard tags for all resources | `map(string)` | n/a | yes |

## Outputs
| Name | Description |
|------|-------------|
| `function_arn` | The ARN of the Lambda function |
| `function_name` | The name of the Lambda function |
| `role_arn` | The ARN of the IAM role used by the function |
| `invoke_arn` | The ARN to be used for invoking the Lambda function from API Gateway |
| `log_group_name` | The name of the CloudWatch log group |
| `kms_key_arn` | The ARN of the KMS key used for encryption |
| `tags` | A map of tags assigned to the Lambda function |

<!-- BEGIN_TF_DOCS -->


## Usage

```hcl
# See README.md for usage example
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_description"></a> [description](#input\_description) | The description of the Lambda function | `string` | n/a | yes |
| <a name="input_function_name"></a> [function\_name](#input\_function\_name) | The name of the Lambda function | `string` | n/a | yes |
| <a name="input_handler"></a> [handler](#input\_handler) | The function entrypoint in your code | `string` | n/a | yes |
| <a name="input_runtime"></a> [runtime](#input\_runtime) | The runtime for the Lambda function | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to the resources | `map(string)` | n/a | yes |
| <a name="input_aws_account_id"></a> [aws\_account\_id](#input\_aws\_account\_id) | The AWS Account ID to support tests/mocking | `string` | `null` | no |
| <a name="input_dead_letter_config_target_arn"></a> [dead\_letter\_config\_target\_arn](#input\_dead\_letter\_config\_target\_arn) | The ARN of an SNS topic or SQS queue to notify when an invocation fails | `string` | `null` | no |
| <a name="input_environment_variables"></a> [environment\_variables](#input\_environment\_variables) | A map of environment variables to assign to the Lambda function | `map(string)` | `{}` | no |
| <a name="input_existing_role_arn"></a> [existing\_role\_arn](#input\_existing\_role\_arn) | The ARN of an existing IAM role to use for the Lambda function. If null, a new role will be created. | `string` | `null` | no |
| <a name="input_file_system_config"></a> [file\_system\_config](#input\_file\_system\_config) | Connection settings for an EFS or S3 file system. Supports mounting a single S3 Files access point or EFS access point. | ```list(object({ arn = string local_mount_path = string }))``` | `[]` | no |
| <a name="input_filename"></a> [filename](#input\_filename) | The path to the function's deployment package within the local filesystem | `string` | `null` | no |
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | The ARN of the KMS key used to encrypt your function's environment variables. If null, a new key will be created. | `string` | `null` | no |
| <a name="input_layers"></a> [layers](#input\_layers) | List of Lambda Layer Version ARNs (maximum of 5) to attach to your Lambda Function | `list(string)` | `[]` | no |
| <a name="input_memory_size"></a> [memory\_size](#input\_memory\_size) | Amount of memory in MB your Lambda Function can use at runtime | `number` | `128` | no |
| <a name="input_permissions_boundary_arn"></a> [permissions\_boundary\_arn](#input\_permissions\_boundary\_arn) | The ARN of the policy that is used to set the permissions boundary for the role | `string` | `null` | no |
| <a name="input_reserved_concurrent_executions"></a> [reserved\_concurrent\_executions](#input\_reserved\_concurrent\_executions) | The amount of reserved concurrent executions for this lambda function. A value of -1 (default) removes any concurrency limitations from the function. | `number` | `-1` | no |
| <a name="input_retention_in_days"></a> [retention\_in\_days](#input\_retention\_in\_days) | Specifies the number of days you want to retain log events in the specified log group | `number` | `30` | no |
| <a name="input_timeout"></a> [timeout](#input\_timeout) | The amount of time your Lambda Function has to run in seconds | `number` | `3` | no |
| <a name="input_vpc_config"></a> [vpc\_config](#input\_vpc\_config) | Provide this to allow your function to access your VPC | ```object({ subnet_ids = list(string) security_group_ids = list(string) })``` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_environment_variables"></a> [environment\_variables](#output\_environment\_variables) | A map of environment variables assigned to the Lambda function |
| <a name="output_function_arn"></a> [function\_arn](#output\_function\_arn) | The ARN of the Lambda function |
| <a name="output_function_name"></a> [function\_name](#output\_function\_name) | The name of the Lambda function |
| <a name="output_invoke_arn"></a> [invoke\_arn](#output\_invoke\_arn) | The ARN to be used for invoking the Lambda function from API Gateway |
| <a name="output_kms_key_arn"></a> [kms\_key\_arn](#output\_kms\_key\_arn) | The ARN of the KMS key used for encryption |
| <a name="output_layers"></a> [layers](#output\_layers) | List of Lambda Layer Version ARNs attached to the function |
| <a name="output_log_group_name"></a> [log\_group\_name](#output\_log\_group\_name) | The name of the CloudWatch log group |
| <a name="output_role_arn"></a> [role\_arn](#output\_role\_arn) | The ARN of the IAM role used by the Lambda function |
| <a name="output_tags"></a> [tags](#output\_tags) | A map of tags assigned to the Lambda function |

<!-- END_TF_DOCS -->