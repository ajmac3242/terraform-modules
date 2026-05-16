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
| `vpc_config` | VPC configuration for the function | `map(any)` | `null` | no |
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
