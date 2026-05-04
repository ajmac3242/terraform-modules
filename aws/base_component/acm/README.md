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
