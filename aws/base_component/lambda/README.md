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
