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
