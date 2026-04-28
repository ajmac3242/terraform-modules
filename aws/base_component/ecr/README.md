# aws/base_component/ecr

## Purpose
Opinionated ECR repository module. Foundational container registry module for ECS and EKS. Centralizes image scanning, immutable tags, and encryption defaults.

## Usage
```hcl
module "ecr" {
  source = "./aws/base_component/ecr"

  repository_name = "my-app"

  tags = {
    environment = "prod"
    owner       = "platform-team"
    project     = "standardization"
    cost_center = "12345"
  }
}
```

## Security
- **Encryption**: Enforces KMS encryption using a Customer Managed Key (CMK). Auto-creates a key if `existing_kms_key_arn` is not provided.
- **Scanning**: Image scanning on push is enabled by default to identify vulnerabilities early.
- **Immutability**: Image tags are immutable by default to prevent accidental overwrites and ensure deployment consistency.

## Variables
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `repository_name` | Name of the ECR repository | `string` | n/a | yes |
| `image_tag_mutability` | The tag mutability setting for the repository | `string` | `"IMMUTABLE"` | no |
| `scan_on_push` | Indicates whether images are scanned after being pushed to the repository | `bool` | `true` | no |
| `existing_kms_key_arn` | ARN of an existing KMS key to use for encryption. If null, a new key is created. | `string` | `null` | no |
| `lifecycle_policy` | JSON string for the ECR lifecycle policy | `string` | `null` | no |
| `tags` | Standard tags for all resources | `map(string)` | n/a | yes |

## Outputs
| Name | Description |
|------|-------------|
| `repository_arn` | The ARN of the ECR repository |
| `repository_name` | The name of the ECR repository |
| `repository_url` | The URL of the ECR repository |
| `kms_key_arn` | The ARN of the KMS key used for encryption |
