# aws/workload_component/apigw_lambda

API Gateway v2 + Lambda pattern. Composed from base modules to eliminate manual wiring of routes, integrations, and permissions.

## Features

- Uses `aws/base_component/lambda` module internally
- `aws_apigatewayv2_api` (HTTP API type)
- `aws_apigatewayv2_integration` linked to Lambda function
- `aws_apigatewayv2_route` with configurable route key
- `aws_apigatewayv2_stage` with `auto_deploy = true` and CloudWatch access logs (encrypted)
- `aws_lambda_permission` granting API GW invoke rights
- Mandatory JWT authorizer (can be disabled)
- Mandatory WAF association
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

  route_key       = "GET /hello"
  jwt_issuer      = "https://example.com"
  jwt_audience    = ["my-audience"]
  waf_web_acl_arn = "arn:aws:wafv2:us-east-1:123456789012:regional/webacl/my-waf/12345678-1234-1234-1234-123456789012"

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
| `jwt_issuer` | The base URL of the IdP that issues JWTs | `string` | `null` | no |
| `jwt_audience` | The list of audiences that are allowed to access the API | `list(string)` | `[]` | no |
| `waf_web_acl_arn` | The ARN of the WAF Web ACL to associate with the API Gateway stage | `string` | n/a | yes |
| `disable_authorizer` | Whether to disable the JWT authorizer for the API Gateway route | `bool` | `false` | no |
| `tags` | A map of tags to assign to the resources. Required keys: `environment`, `owner`, `project`, `cost_center`. | `map(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| `api_endpoint` | The HTTP API endpoint |
| `api_id` | The ID of the API Gateway |
| `function_arn` | The ARN of the Lambda function |
| `stage_id` | The ID of the API Gateway stage |
| `route_id` | The ID of the API Gateway route |
| `authorizer_id` | The ID of the API Gateway authorizer |
