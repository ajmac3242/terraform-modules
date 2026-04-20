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
