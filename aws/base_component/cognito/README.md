# aws/base_component/cognito

## Purpose
Opinionated Cognito User Pool module. Essential for modern serverless authentication patterns, enforcing advanced security settings and secure client defaults.

## Usage
```hcl
module "cognito" {
  source = "./aws/base_component/cognito"

  user_pool_name = "my-user-pool"
  client_name    = "my-app-client"

  tags = {
    environment = "prod"
    owner       = "platform-team"
    project     = "standardization"
    cost_center = "12345"
  }
}
```

## Security
- **Encryption**: Data is encrypted at rest by default using AWS-managed keys (CMK not currently supported for User Pool storage).
- **Advanced Security**: Enabled by default (ENFORCED).
- **Client Security**: No client secret generated for SPAs by default; SRP and Refresh Token auth flows only.

## Variables
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `user_pool_name` | Name of the Cognito User Pool | `string` | n/a | yes |
| `client_name` | Name of the Cognito User Pool Client | `string` | n/a | yes |
| `advanced_security_mode` | Advanced security mode. Must be one of: AUDIT, ENFORCED | `string` | `"ENFORCED"` | no |
| `tags` | Standard tags for all resources | `map(string)` | n/a | yes |

## Outputs
| Name | Description |
|------|-------------|
| `user_pool_id` | The ID of the User Pool |
| `user_pool_arn` | The ARN of the User Pool |
| `client_id` | The ID of the User Pool Client |
| `tags` | A map of tags assigned to the resource |

<!-- BEGIN_TF_DOCS -->


## Usage

```hcl
# See README.md for usage example
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_client_name"></a> [client\_name](#input\_client\_name) | Name of the Cognito User Pool Client | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to the resources. Required keys: environment, owner, project, cost\_center. | `map(string)` | n/a | yes |
| <a name="input_user_pool_name"></a> [user\_pool\_name](#input\_user\_pool\_name) | Name of the Cognito User Pool | `string` | n/a | yes |
| <a name="input_advanced_security_mode"></a> [advanced\_security\_mode](#input\_advanced\_security\_mode) | Advanced security mode. Must be one of: AUDIT, ENFORCED | `string` | `"ENFORCED"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_client_id"></a> [client\_id](#output\_client\_id) | The ID of the User Pool Client |
| <a name="output_tags"></a> [tags](#output\_tags) | A map of tags assigned to the resource |
| <a name="output_user_pool_arn"></a> [user\_pool\_arn](#output\_user\_pool\_arn) | The ARN of the User Pool |
| <a name="output_user_pool_id"></a> [user\_pool\_id](#output\_user\_pool\_id) | The ID of the User Pool |

<!-- END_TF_DOCS -->