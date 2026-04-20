# aws/base_component/iam

Opinionated IAM role module. Enforces least-privilege patterns with managed policy attachments only — no inline policies.

## Features

- Creates IAM role with configurable assume-role policy
- Attaches list of managed policy ARNs
- No inline policies (by design)
- Optional permission boundary support
- Required tags enforced

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
    project     = "my-app"
    cost_center = "CC-1234"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `role_name` | The name of the IAM role. (1–64 chars, alphanumeric + +=,.@_/-) | `string` | n/a | yes |
| `description` | The description of the IAM role | `string` | n/a | yes |
| `assume_role_policy` | The assume role policy for the IAM role (JSON string) | `string` | n/a | yes |
| `managed_policy_arns` | A list of managed policy ARNs to attach to the IAM role | `list(string)` | `[]` | no |
| `permissions_boundary_arn` | The ARN of the policy that is used to set the permissions boundary for the role | `string` | `null` | no |
| `tags` | A map of tags to assign to the resources. Required keys: `environment`, `owner`, `project`, `cost_center`. | `map(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| `role_arn` | The ARN of the IAM role |
| `role_name` | The name of the IAM role |
| `role_id` | The stable and unique string identifying the role |
| `unique_id` | The unique ID assigned by AWS |
