# aws/base_component/wafv2

## Purpose
Opinionated WAFv2 Web ACL module. Centralized web application firewall with standard rule sets and visibility for protecting ALBs, CloudFront, and API Gateway.

## Usage
```hcl
module "waf" {
  source = "./aws/base_component/wafv2"

  name  = "my-web-acl"
  scope = "REGIONAL"

  tags = {
    environment = "prod"
    owner       = "platform-team"
    project     = "standardization"
    cost_center = "12345"
  }
}
```

## Security
- **Protection**: Includes `AWSManagedRulesCommonRuleSet` by default to protect against common web exploits (OWASP Top 10).
- **Visibility**: CloudWatch metrics and sampled requests are enabled for all rules.
- **Scope**: Supports both `REGIONAL` (ALB, API GW) and `CLOUDFRONT` scopes.

## Variables
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `name` | Name of the Web ACL | `string` | n/a | yes |
| `scope` | The scope of this Web ACL. Valid values are CLOUDFRONT and REGIONAL. | `string` | `"REGIONAL"` | no |
| `enable_common_rule_set` | Whether to enable the AWS Managed Common Rule Set | `bool` | `true` | no |
| `tags` | Standard tags for all resources | `map(string)` | n/a | yes |

## Outputs
| Name | Description |
|------|-------------|
| `web_acl_arn` | The ARN of the WAF Web ACL |
| `web_acl_id` | The ID of the WAF Web ACL |
| `web_acl_name` | The name of the WAF Web ACL |
| `tags` | A map of tags assigned to the resource |

<!-- BEGIN_TF_DOCS -->


## Usage

```hcl
# See README.md for usage example
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | The name of the Web ACL | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to the resources | `map(string)` | n/a | yes |
| <a name="input_scope"></a> [scope](#input\_scope) | The scope of this Web ACL. Valid values are CLOUDFRONT and REGIONAL | `string` | `"REGIONAL"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_tags"></a> [tags](#output\_tags) | A map of tags assigned to the resource |
| <a name="output_web_acl_arn"></a> [web\_acl\_arn](#output\_web\_acl\_arn) | The ARN of the Web ACL |
| <a name="output_web_acl_id"></a> [web\_acl\_id](#output\_web\_acl\_id) | The ID of the Web ACL |

<!-- END_TF_DOCS -->