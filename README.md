# terraform-modules

Opinionated, organization-wide Terraform modules for multi-cloud infrastructure. Starting with AWS, these modules wrap upstream providers and registries to enforce security, consistency, and developer ease-of-use by default.

Developers consume these modules instead of raw provider resources, so that security guardrails, tagging standards, and best practices are baked in — not bolted on.

## Philosophy

- **Security by default** — CMK encryption, least-privilege IAM, no public access, logging enabled out of the box
- **Opinionated, not restrictive** — sane defaults with escape hatches where needed
- **Composable** — base components combine into workload patterns
- **Registry-ready** — structure designed to be split into a Terraform module registry

## Repository Structure

```
terraform-modules/
  aws/
    base_component/         # Single-service opinionated wrappers
      s3/                   # S3 bucket with CMK, versioning, logging
      lambda/               # Lambda function with CW logs, X-Ray, IAM
      kms/                  # KMS CMK with rotation and least-privilege policy
      vpc/                  # VPC with flow logs and secure defaults
      iam/                  # IAM roles and policies with least-privilege
    workload_component/     # Composed multi-service patterns
      api_gateway_lambda/   # API Gateway + Lambda with auth and logging
  .Jules/
    backlog.md              # Shared agent + human backlog
    sentinel.md             # Sentinel (security agent) journal
    forge.md                # Forge (developer agent) journal
```

## Module Conventions

Every module follows this structure:

```
<module>/
  main.tf        - Primary resources
  variables.tf   - All inputs (typed + described)
  outputs.tf     - All outputs (described)
  versions.tf    - Provider and Terraform version constraints
  README.md      - Usage example, inputs table, outputs table
```

### Required Tags

All modules require and apply these tags to every taggable resource:

| Tag | Description |
|-----|-------------|
| `environment` | e.g. dev, staging, prod |
| `owner` | Team or individual responsible |
| `project` | Project or application name |
| `cost_center` | Cost allocation code |

## Agents

This repo is maintained by two Jules AI agents running on a daily schedule:

| Agent | Schedule | Role |
|-------|----------|------|
| **Sentinel** 🛡️ | Daily at midnight | Security auditor — scans modules, opens fix PRs and issues |
| **Forge** 🔨 | Daily at noon | Developer — implements backlog items, builds new modules |

See `.Jules/backlog.md` to view or add work items for either agent.

## Getting Started

```hcl
module "my_bucket" {
  source = "./aws/base_component/s3"

  bucket_name  = "my-app-data"
  environment  = "prod"
  owner        = "platform-team"
  project      = "my-app"
  cost_center  = "CC-1234"
}
```

## Contributing

See [CONTRIBUTING.md](./CONTRIBUTING.md) for guidelines. To request a new module or enhancement, add an item to `.Jules/backlog.md` following the template in that file.
