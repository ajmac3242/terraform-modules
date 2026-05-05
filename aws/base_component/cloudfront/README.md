# Purpose

Opinionated CloudFront distribution module. Enforces TLS 1.2+, mandatory WAF integration, and S3 access logging.

## Usage

```hcl
module "cloudfront" {
  source = "./aws/base_component/cloudfront"

  origin_domain_name      = "my-bucket.s3.amazonaws.com"
  origin_id               = "S3-my-bucket"
  waf_web_acl_id          = "arn:aws:wafv2:us-east-1:123456789012:regional/webacl/..."
  log_bucket_domain_name  = "logs.s3.amazonaws.com"

  tags = {
    environment = "prod"
    owner       = "platform-team"
    project     = "my-app"
    cost_center = "CC-1234"
  }
}
```

## Security

- **TLS Enforcement**: Minimum protocol version is set to `TLSv1.2_2021`.
- **WAF Integration**: Association with a WAF Web ACL is mandatory.
- **Logging**: Access logging to a designated S3 bucket is enabled by default.
- **Encryption**: Uses default CloudFront certificates or ACM certificates (recommended).

## Variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `origin_domain_name` | The domain name for the origin | `string` | n/a | yes |
| `origin_id` | A unique identifier for the origin | `string` | n/a | yes |
| `waf_web_acl_id` | The ID of the WAF Web ACL | `string` | n/a | yes |
| `log_bucket_domain_name` | S3 bucket domain for access logs | `string` | n/a | yes |
| `tags` | A map of tags to assign to the resources. Required keys: `environment`, `owner`, `project`, `cost_center`. | `map(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| `distribution_id` | The ID of the distribution |
| `distribution_arn` | The ARN of the distribution |
| `distribution_domain_name` | The domain name of the distribution |
