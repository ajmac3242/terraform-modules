# aws/base_component/lambda

Opinionated Lambda function module. Centralizing execution role creation, VPC config, CMK env var encryption, X-Ray tracing, and CW log groups.

## Features

- `aws_lambda_function` with configurable runtime, handler, memory, timeout
- Execution role created via `aws/base_component/iam` module
- `aws_cloudwatch_log_group` with configurable `retention_in_days` (default: 30)
- X-Ray `tracing_config` set to `Active` by default
- Optional `vpc_config` for VPC placement
- KMS key for environment variable encryption (`kms_key_arn` input)
- Reserved concurrency support
- Required tags enforced

## Usage

```hcl
module "lambda" {
  source = "./aws/base_component/lambda"

  function_name = "my-process-data"
  description   = "Processes data from S3"
  runtime       = "nodejs18.x"
  handler       = "index.handler"
  filename      = "function.zip"

  environment_variables = {
    DB_TABLE = "my-table"
  }

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
| `function_name` | The name of the Lambda function | `string` | n/a | yes |
| `description` | The description of the Lambda function | `string` | n/a | yes |
| `runtime` | The runtime for the Lambda function | `string` | n/a | yes |
| `handler` | The function entrypoint in your code | `string` | n/a | yes |
| `memory_size` | Amount of memory in MB your Lambda Function can use at runtime | `number` | `128` | no |
| `timeout` | The amount of time your Lambda Function has to run in seconds | `number` | `3` | no |
| `filename` | The path to the function's deployment package within the local filesystem | `string` | `null` | no |
| `environment_variables` | A map of environment variables to assign to the Lambda function | `map(string)` | `{}` | no |
| `kms_key_arn` | The ARN of the KMS key used to encrypt your function's environment variables | `string` | `null` | no |
| `vpc_config` | Provide this to allow your function to access your VPC | `object` | `null` | no |
| `retention_in_days` | Specifies the number of days you want to retain log events in the specified log group | `number` | `30` | no |
| `reserved_concurrent_executions` | The amount of reserved concurrent executions for this lambda function | `number` | `-1` | no |
| `tags` | A map of tags to assign to the resources. Required keys: `environment`, `owner`, `project`, `cost_center`. | `map(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| `function_arn` | The ARN of the Lambda function |
| `function_name` | The name of the Lambda function |
| `role_arn` | The ARN of the IAM role created for the Lambda function |
| `invoke_arn` | The ARN to be used for invoking the Lambda function from API Gateway |
| `log_group_name` | The name of the CloudWatch log group |

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
| <a name="input_filename"></a> [filename](#input\_filename) | The path to the function's deployment package within the local filesystem | `string` | `null` | no |
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | The ARN of the KMS key used to encrypt your function's environment variables. If null, a new key will be created. | `string` | `null` | no |
| <a name="input_memory_size"></a> [memory\_size](#input\_memory\_size) | Amount of memory in MB your Lambda Function can use at runtime | `number` | `128` | no |
| <a name="input_reserved_concurrent_executions"></a> [reserved\_concurrent\_executions](#input\_reserved\_concurrent\_executions) | The amount of reserved concurrent executions for this lambda function. A value of -1 (default) removes any concurrency limitations from the function. | `number` | `-1` | no |
| <a name="input_retention_in_days"></a> [retention\_in\_days](#input\_retention\_in\_days) | Specifies the number of days you want to retain log events in the specified log group | `number` | `30` | no |
| <a name="input_timeout"></a> [timeout](#input\_timeout) | The amount of time your Lambda Function has to run in seconds | `number` | `3` | no |
| <a name="input_vpc_config"></a> [vpc\_config](#input\_vpc\_config) | Provide this to allow your function to access your VPC | ```object({ subnet_ids = list(string) security_group_ids = list(string) })``` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_function_arn"></a> [function\_arn](#output\_function\_arn) | The ARN of the Lambda function |
| <a name="output_function_name"></a> [function\_name](#output\_function\_name) | The name of the Lambda function |
| <a name="output_invoke_arn"></a> [invoke\_arn](#output\_invoke\_arn) | The ARN to be used for invoking the Lambda function from API Gateway |
| <a name="output_kms_key_arn"></a> [kms\_key\_arn](#output\_kms\_key\_arn) | The ARN of the KMS key used for encryption |
| <a name="output_log_group_name"></a> [log\_group\_name](#output\_log\_group\_name) | The name of the CloudWatch log group |
| <a name="output_role_arn"></a> [role\_arn](#output\_role\_arn) | The ARN of the IAM role used by the Lambda function |

<!-- END_TF_DOCS -->