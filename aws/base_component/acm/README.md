# aws/base_component/acm

## Purpose
Opinionated ACM Certificate module. Standardizes certificate management with `create_before_destroy` lifecycle and tagging.

## Usage
```hcl
module "acm" {
  source = "./aws/base_component/acm"

  domain_name = "example.com"

  tags = {
    environment = "prod"
    owner       = "platform-team"
    project     = "standardization"
    cost_center = "12345"
  }
}
```

## Security
- **Lifecycle**: `create_before_destroy` is enforced to prevent downtime during certificate renewals.
- **Validation**: Supports DNS validation (Route 53 records must be created separately or via the `route53` module).

## Variables
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `domain_name` | The domain name for which the certificate should be issued | `string` | n/a | yes |
| region | The AWS region to provision the certificate in (AWS Provider 6.0+) | `string` | `null` | no |
| `validation_method` | Which method to use for validation. DNS or EMAIL. | `string` | `"DNS"` | no |
| `subject_alternative_names` | Set of domains that should be SANs in the issued certificate | `list(string)` | `[]` | no |
| `tags` | Standard tags for all resources | `map(string)` | n/a | yes |

## Outputs
| Name | Description |
|------|-------------|
| `certificate_arn` | The ARN of the certificate |
| `domain_name` | The domain name for which the certificate should be issued |
| `tags` | A map of tags assigned to the resource |

<!-- BEGIN_TF_DOCS -->


## Usage

```hcl
# See README.md for usage example
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | The domain name for which the certificate should be issued | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to the resources | `map(string)` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The AWS region to provision the certificate in (AWS Provider 6.0+) | `string` | `null` | no |
| <a name="input_subject_alternative_names"></a> [subject\_alternative\_names](#input\_subject\_alternative\_names) | Set of domains that should be SANs in the issued certificate | `list(string)` | `[]` | no |
| <a name="input_validation_method"></a> [validation\_method](#input\_validation\_method) | Which method to use for validation. DNS or EMAIL | `string` | `"DNS"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_certificate_arn"></a> [certificate\_arn](#output\_certificate\_arn) | The ARN of the certificate |
| <a name="output_domain_validation_options"></a> [domain\_validation\_options](#output\_domain\_validation\_options) | Set of domain validation objects which can be used to complete certificate validation |
| <a name="output_tags"></a> [tags](#output\_tags) | A map of tags assigned to the resource |

<!-- END_TF_DOCS -->