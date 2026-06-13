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
| `cache_tag_config_header_name` | The header name to use for cache tagging | `string` | `null` | no |
| `tags` | A map of tags to assign to the resources. Required keys: `environment`, `owner`, `project`, `cost_center`. | `map(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| `distribution_id` | The ID of the distribution |
| `distribution_arn` | The ARN of the distribution |
| `distribution_domain_name` | The domain name of the distribution |
| `tags` | A map of tags assigned to the resource |

<!-- BEGIN_TF_DOCS -->


## Usage

```hcl
# See README.md for usage example
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_log_bucket_domain_name"></a> [log\_bucket\_domain\_name](#input\_log\_bucket\_domain\_name) | The domain name of the S3 bucket for access logs | `string` | n/a | yes |
| <a name="input_origin_domain_name"></a> [origin\_domain\_name](#input\_origin\_domain\_name) | The domain name for the origin | `string` | n/a | yes |
| <a name="input_origin_id"></a> [origin\_id](#input\_origin\_id) | A unique identifier for the origin | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to the resources | `map(string)` | n/a | yes |
| <a name="input_waf_web_acl_id"></a> [waf\_web\_acl\_id](#input\_waf\_web\_acl\_id) | The ID of the WAF Web ACL to associate with the distribution | `string` | n/a | yes |
| <a name="input_origin_type"></a> [origin\_type](#input\_origin\_type) | The type of origin (S3 or ALB) | `string` | `"S3"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_distribution_arn"></a> [distribution\_arn](#output\_distribution\_arn) | The ARN of the distribution |
| <a name="output_distribution_domain_name"></a> [distribution\_domain\_name](#output\_distribution\_domain\_name) | The domain name of the distribution |
| <a name="output_distribution_id"></a> [distribution\_id](#output\_distribution\_id) | The ID of the distribution |
| <a name="output_tags"></a> [tags](#output\_tags) | A map of tags assigned to the resource |

<!-- END_TF_DOCS -->