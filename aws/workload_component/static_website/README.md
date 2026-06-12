# aws/workload_component/static_website

## Purpose
High-demand pattern for hosting frontend SPAs. Composes multiple base components into a secure, performant, and cost-effective hosting solution with TLS and custom domain support.

## Usage
```hcl
module "static_website" {
  source = "./aws/workload_component/static_website"

  domain_name     = "example.com"
  route53_zone_id = "Z1234567890"
  waf_web_acl_arn = "arn:aws:wafv2:us-east-1:123456789012:global/webacl/my-waf/1234..."
  log_bucket_id   = "my-logs-bucket"

  tags = {
    environment = "prod"
    owner       = "platform-team"
    project     = "standardization"
    cost_center = "12345"
  }
}
```

## Security
- **Encryption**: S3 origin bucket is encrypted via CMK. CloudFront enforces TLS 1.2+ for all viewer traffic.
- **Protection**: Mandatory WAFv2 association for the CloudFront distribution. Public access to the S3 bucket is blocked, and access is restricted to CloudFront via Origin Access Control (OAC).
- **Identity**: Least-privilege S3 bucket policy allowing only the CloudFront distribution to fetch objects.

## Variables
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `domain_name` | The primary domain name for the website | `string` | n/a | yes |
| `alternate_domains` | List of alternate domain names (CNAMEs) | `list(string)` | `[]` | no |
| `route53_zone_id` | The Route 53 Hosted Zone ID | `string` | n/a | yes |
| `waf_web_acl_arn` | The ARN of the WAFv2 Web ACL (Global, us-east-1) | `string` | n/a | yes |
| `log_bucket_id` | The ID of the S3 bucket for access logs | `string` | n/a | yes |
| `tags` | Standard tags for all resources | `map(string)` | n/a | yes |

## Outputs
| Name | Description |
|------|-------------|
| `s3_bucket_id` | The ID of the S3 bucket |
| `s3_bucket_arn` | The ARN of the S3 bucket |
| `cloudfront_distribution_id` | The ID of the CloudFront distribution |
| `cloudfront_distribution_arn` | The ARN of the CloudFront distribution |
| `cloudfront_domain_name` | The domain name of the CloudFront distribution |
| `website_url` | The primary URL of the website |
| `tags` | A map of tags assigned to the resources |

<!-- BEGIN_TF_DOCS -->


## Usage

```hcl
# See README.md for usage example
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | The primary domain name for the website (e.g. example.com) | `string` | n/a | yes |
| <a name="input_log_bucket_id"></a> [log\_bucket\_id](#input\_log\_bucket\_id) | The ID of the S3 bucket to store access logs | `string` | n/a | yes |
| <a name="input_route53_zone_id"></a> [route53\_zone\_id](#input\_route53\_zone\_id) | The Route 53 Hosted Zone ID where the records will be created | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Standard tags for all resources | `map(string)` | n/a | yes |
| <a name="input_waf_web_acl_arn"></a> [waf\_web\_acl\_arn](#input\_waf\_web\_acl\_arn) | The ARN of the WAFv2 Web ACL to associate with the CloudFront distribution. Must be in us-east-1. | `string` | n/a | yes |
| <a name="input_alternate_domains"></a> [alternate\_domains](#input\_alternate\_domains) | List of alternate domain names (CNAMEs) for the website | `list(string)` | `[]` | no |
| <a name="input_aws_account_id"></a> [aws\_account\_id](#input\_aws\_account\_id) | The AWS Account ID to support tests/mocking | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cloudfront_distribution_arn"></a> [cloudfront\_distribution\_arn](#output\_cloudfront\_distribution\_arn) | The ARN of the CloudFront distribution |
| <a name="output_cloudfront_distribution_id"></a> [cloudfront\_distribution\_id](#output\_cloudfront\_distribution\_id) | The ID of the CloudFront distribution |
| <a name="output_cloudfront_domain_name"></a> [cloudfront\_domain\_name](#output\_cloudfront\_domain\_name) | The domain name of the CloudFront distribution |
| <a name="output_s3_bucket_arn"></a> [s3\_bucket\_arn](#output\_s3\_bucket\_arn) | The ARN of the S3 bucket |
| <a name="output_s3_bucket_id"></a> [s3\_bucket\_id](#output\_s3\_bucket\_id) | The ID of the S3 bucket |
| <a name="output_tags"></a> [tags](#output\_tags) | A map of tags assigned to the resources |
| <a name="output_website_url"></a> [website\_url](#output\_website\_url) | The primary URL of the website |

<!-- END_TF_DOCS -->