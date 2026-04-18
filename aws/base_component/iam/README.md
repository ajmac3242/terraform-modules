# aws/base_component/iam

> **Status: Backlog** — Implementation pending. See `.Jules/backlog.md` for requirements and acceptance criteria.

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
  assume_role_policy = data.aws_iam_policy_document.lambda_assume.json
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

## Outputs

| Name | Description |
|------|-------------|
| `role_arn` | IAM role ARN |
| `role_name` | IAM role name |
| `role_id` | IAM role unique ID |
