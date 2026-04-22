# aws/workload_component/apigw_lambda

API Gateway v2 + Lambda pattern. Composed from base modules to eliminate manual wiring of routes, integrations, and permissions.

## Features

- Uses `aws/base_component/lambda` module internally
- `aws_apigatewayv2_api` (HTTP API type)
- `aws_apigatewayv2_integration` linked to Lambda function
- `aws_apigatewayv2_route` with configurable route key
- `aws_apigatewayv2_stage` with `auto_deploy = true` and CloudWatch access logs (encrypted)
- `aws_lambda_permission` granting API GW invoke rights
- Required tags enforced

## Usage

```hcl
module "apigw_lambda" {
  source = "./aws/workload_component/apigw_lambda"

  name        = "my-api"
  description = "My Serverless API"
  runtime     = "nodejs18.x"
  handler     = "index.handler"
  filename    = "function.zip"
  kms_key_arn = module.kms.key_arn

  route_key = "GET /hello"

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
| `name` | The name of the API Gateway and Lambda function | `string` | n/a | yes |
| `description` | The description of the API Gateway and Lambda function | `string` | n/a | yes |
| `runtime` | The runtime for the Lambda function | `string` | n/a | yes |
| `handler` | The function entrypoint in your code | `string` | n/a | yes |
| `filename` | The path to the function's deployment package | `string` | `null` | no |
| `route_key` | The route key for the API Gateway | `string` | `"$default"` | no |
| `kms_key_arn` | The ARN of the KMS key for encryption | `string` | n/a | yes |
| `tags` | A map of tags to assign to the resources. Required keys: `environment`, `owner`, `project`, `cost_center`. | `map(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| `api_endpoint` | The HTTP API endpoint |
| `api_id` | The ID of the API Gateway |
| `function_arn` | The ARN of the Lambda function |

<!-- BEGIN_TF_DOCS -->


## Usage

```hcl
# See README.md for usage example
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_description"></a> [description](#input\_description) | The description of the API Gateway and Lambda function | `string` | n/a | yes |
| <a name="input_handler"></a> [handler](#input\_handler) | The function entrypoint in your code | `string` | n/a | yes |
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | The ARN of the KMS key for encryption | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | The name of the API Gateway and Lambda function | `string` | n/a | yes |
| <a name="input_runtime"></a> [runtime](#input\_runtime) | The runtime for the Lambda function | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to the resources | `map(string)` | n/a | yes |
| <a name="input_filename"></a> [filename](#input\_filename) | The path to the function's deployment package within the local filesystem | `string` | `null` | no |
| <a name="input_route_key"></a> [route\_key](#input\_route\_key) | The route key for the API Gateway (e.g., 'POST /items') | `string` | `"$default"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_api_endpoint"></a> [api\_endpoint](#output\_api\_endpoint) | The HTTP API endpoint |
| <a name="output_api_id"></a> [api\_id](#output\_api\_id) | The ID of the API Gateway |
| <a name="output_function_arn"></a> [function\_arn](#output\_function\_arn) | The ARN of the Lambda function |

<!-- END_TF_DOCS -->