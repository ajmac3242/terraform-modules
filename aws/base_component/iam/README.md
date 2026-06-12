# aws/base_component/iam

## Purpose
Opinionated IAM role module. Enforces least-privilege patterns with managed policy attachments only — no inline policies allowed.

## Usage
```hcl
module "iam_role" {
  source = "./aws/base_component/iam"

  role_name         = "my-app-lambda-role"
  description       = "Execution role for my-app Lambda functions"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  ]

  tags = {
    environment = "prod"
    owner       = "platform-team"
    project     = "standardization"
    cost_center = "12345"
  }
}
```

## Security
- **Least Privilege**: Managed policies only. No inline policies are permitted by design.
- **Boundaries**: Supports `permissions_boundary_arn` to restrict the maximum permissions the role can have.
- **Validation**: Role name and policy ARNs are validated via regex.

## Variables
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `role_name` | The name of the IAM role. (1–64 chars, alphanumeric + +=,.@_/-) | `string` | n/a | yes |
| `description` | The description of the IAM role | `string` | n/a | yes |
| `assume_role_policy` | The assume role policy for the IAM role (JSON string) | `string` | n/a | yes |
| `managed_policy_arns` | A list of managed policy ARNs to attach to the IAM role | `list(string)` | `[]` | no |
| `permissions_boundary_arn` | The ARN of the policy that is used to set the permissions boundary for the role | `string` | `null` | no |
| `tags` | Standard tags for all resources | `map(string)` | n/a | yes |

## Outputs
| Name | Description |
|------|-------------|
| `role_arn` | The ARN of the IAM role |
| `role_name` | The name of the IAM role |
| `role_id` | The stable and unique string identifying the role |
| `unique_id` | The unique ID assigned by AWS |
| `tags` | A map of tags assigned to the resource |

<!-- BEGIN_TF_DOCS -->


## Usage

```hcl
# See README.md for usage example
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_assume_role_policy"></a> [assume\_role\_policy](#input\_assume\_role\_policy) | The assume role policy for the IAM role (JSON string) | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | The description of the IAM role | `string` | n/a | yes |
| <a name="input_role_name"></a> [role\_name](#input\_role\_name) | The name of the IAM role. (1–64 chars, alphanumeric + +=,.@\_/-) | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to the resources | `map(string)` | n/a | yes |
| <a name="input_managed_policy_arns"></a> [managed\_policy\_arns](#input\_managed\_policy\_arns) | A list of managed policy ARNs to attach to the IAM role | `list(string)` | `[]` | no |
| <a name="input_permissions_boundary_arn"></a> [permissions\_boundary\_arn](#input\_permissions\_boundary\_arn) | The ARN of the policy that is used to set the permissions boundary for the role | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_role_arn"></a> [role\_arn](#output\_role\_arn) | The ARN of the IAM role |
| <a name="output_role_id"></a> [role\_id](#output\_role\_id) | The stable and unique string identifying the role |
| <a name="output_role_name"></a> [role\_name](#output\_role\_name) | The name of the IAM role |
| <a name="output_tags"></a> [tags](#output\_tags) | A map of tags assigned to the resource |
| <a name="output_unique_id"></a> [unique\_id](#output\_unique\_id) | The unique ID assigned by AWS |

<!-- END_TF_DOCS -->