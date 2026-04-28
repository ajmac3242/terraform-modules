# aws/workload_component/apigw_lambda

## Purpose
API Gateway v2 + Lambda pattern. The most common serverless pattern, eliminating the need to wire up routes, integrations, and permissions separately while enforcing JWT authorization.

## Usage
```hcl
module "api" {
  source = "./aws/workload_component/apigw_lambda"

  name          = "my-api"
  route_key     = "POST /items"
  jwt_issuer    = "https://cognito-idp.us-east-1.amazonaws.com/us-east-1_..."
  jwt_audience  = ["my-client-id"]
  kms_key_arn   = module.kms.key_arn
  waf_web_acl_arn = module.waf.web_acl_arn

  tags = {
    environment = "prod"
    owner       = "platform-team"
    project     = "standardization"
    cost_center = "12345"
  }
}
```

## Security
- **Authentication**: JWT authorizer is required by default for all routes.
- **Protection**: Mandatory WAFv2 association at the Stage level.
- **Encryption**: Lambda environment variables and CloudWatch logs are encrypted using a CMK.
- **Visibility**: API Gateway access logging to CloudWatch is enabled by default.

## Variables
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `name` | Name of the API and Lambda function | `string` | n/a | yes |
| `route_key` | Route key for the API (e.g., "GET /items") | `string` | n/a | yes |
| `jwt_issuer` | JWT issuer URL for the authorizer | `string` | `null` | no |
| `jwt_audience` | List of allowed JWT audiences | `list(string)` | `[]` | no |
| `disable_authorizer` | Whether to disable the JWT authorizer (not recommended) | `bool` | `false` | no |
| `kms_key_arn` | KMS key ARN for encryption | `string` | n/a | yes |
| `waf_web_acl_arn` | ARN of the WAFv2 Web ACL to associate with the stage | `string` | n/a | yes |
| `tags` | Standard tags for all resources | `map(string)` | n/a | yes |

## Outputs
| Name | Description |
|------|-------------|
| `api_endpoint` | The HTTP endpoint for the API |
| `api_id` | The ID of the API Gateway |
| `function_arn` | The ARN of the Lambda function |
| `stage_id` | The ID of the API stage |
| `route_id` | The ID of the API route |
