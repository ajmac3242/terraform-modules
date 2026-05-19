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
| `tags` | A map of tags assigned to the resources |

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
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to the resources. Must include environment, owner, project, and cost\_center. | `map(string)` | n/a | yes |
| <a name="input_waf_web_acl_arn"></a> [waf\_web\_acl\_arn](#input\_waf\_web\_acl\_arn) | The ARN of the WAF Web ACL to associate with the API Gateway stage | `string` | n/a | yes |
| <a name="input_aws_account_id"></a> [aws\_account\_id](#input\_aws\_account\_id) | The AWS Account ID to support tests/mocking | `string` | `null` | no |
| <a name="input_certificate_arn"></a> [certificate\_arn](#input\_certificate\_arn) | The ARN of the ACM certificate for the custom domain | `string` | `null` | no |
| <a name="input_cors_configuration"></a> [cors\_configuration](#input\_cors\_configuration) | CORS configuration for the HTTP API | ```object({ allow_credentials = optional(bool) allow_headers = optional(list(string)) allow_methods = optional(list(string)) allow_origins = optional(list(string)) expose_headers = optional(list(string)) max_age = optional(number) })``` | `null` | no |
| <a name="input_disable_authorizer"></a> [disable\_authorizer](#input\_disable\_authorizer) | Whether to disable the JWT authorizer for the API Gateway route | `bool` | `false` | no |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | Custom domain name for the API Gateway | `string` | `null` | no |
| <a name="input_filename"></a> [filename](#input\_filename) | The path to the function's deployment package within the local filesystem | `string` | `null` | no |
| <a name="input_jwt_audience"></a> [jwt\_audience](#input\_jwt\_audience) | The list of audiences that are allowed to access the API | `list(string)` | `[]` | no |
| <a name="input_jwt_issuer"></a> [jwt\_issuer](#input\_jwt\_issuer) | The base URL of the IdP that issues JWTs | `string` | `null` | no |
| <a name="input_permissions_boundary_arn"></a> [permissions\_boundary\_arn](#input\_permissions\_boundary\_arn) | The ARN of the policy that is used to set the permissions boundary for the role | `string` | `null` | no |
| <a name="input_route_key"></a> [route\_key](#input\_route\_key) | The route key for the API Gateway (e.g., 'POST /items') | `string` | `"$default"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_api_arn"></a> [api\_arn](#output\_api\_arn) | The ARN of the API Gateway |
| <a name="output_api_endpoint"></a> [api\_endpoint](#output\_api\_endpoint) | The HTTP API endpoint |
| <a name="output_api_id"></a> [api\_id](#output\_api\_id) | The ID of the API Gateway |
| <a name="output_authorizer_id"></a> [authorizer\_id](#output\_authorizer\_id) | The ID of the API Gateway authorizer |
| <a name="output_function_arn"></a> [function\_arn](#output\_function\_arn) | The ARN of the Lambda function |
| <a name="output_role_arn"></a> [role\_arn](#output\_role\_arn) | The ARN of the IAM role used by the Lambda function |
| <a name="output_route_id"></a> [route\_id](#output\_route\_id) | The ID of the API Gateway route |
| <a name="output_stage_arn"></a> [stage\_arn](#output\_stage\_arn) | The ARN of the API Gateway stage |
| <a name="output_tags"></a> [tags](#output\_tags) | A map of tags assigned to the resources |

<!-- END_TF_DOCS -->