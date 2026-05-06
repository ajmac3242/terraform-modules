# API Gateway v2 (HTTP) Base Module

## Purpose

This module provisions an opinionated AWS API Gateway v2 HTTP API. It standardizes the setup of HTTP APIs with mandatory CloudWatch access logging, CMK encryption for logs, and support for custom domains and CORS.

## Usage

```hcl
module "api" {
  source = "./aws/base_component/apigateway_v2"

  name        = "my-http-api"
  kms_key_arn = "arn:aws:kms:us-east-1:123456789012:key/my-key-id"

  cors_configuration = {
    allow_origins = ["https://example.com"]
    allow_methods = ["GET", "POST"]
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

- **Encryption**: API Gateway access logs are encrypted using a mandatory Customer Managed Key (CMK).
- **Protocol**: Exclusively supports HTTP APIs for performance and cost efficiency.
- **Logging**: Access logging to CloudWatch is enabled by default with a 30-day retention policy.
- **Custom Domains**: Supports TLS 1.2 for custom domain configurations.

## Variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | The name of the API Gateway | `string` | n/a | yes |
| kms_key_arn | The ARN of the KMS key for log group encryption | `string` | n/a | yes |
| cors_configuration | CORS configuration for the HTTP API | `object` | `null` | no |
| domain_name | Custom domain name for the API Gateway | `string` | `null` | no |
| certificate_arn | The ARN of the ACM certificate for the custom domain | `string` | `null` | no |
| tags | A map of tags to assign to the resources | `map(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| api_id | The ID of the API Gateway |
| api_arn | The ARN of the API Gateway |
| api_endpoint | The HTTP endpoint for the API |
| execution_arn | The execution ARN of the API Gateway |
| stage_arn | The ARN of the API Gateway stage |
| log_group_arn | The ARN of the CloudWatch log group for access logs |
| tags | A map of tags assigned to the resource |
