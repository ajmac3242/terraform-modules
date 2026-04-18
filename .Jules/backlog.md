# Terraform Modules — Product Backlog

> **Maintained by:** Sentinel (nightly) + Forge (marks items done)
> **Last reviewed:** <!-- Sentinel updates this on each run -->
> **Purpose:** Single source of truth for all module requirements, acceptance criteria, security findings, and feature requests across this multi-cloud Terraform module registry.

---

## How This File Works

- **Sentinel** (Jules, runs nightly at 12:00 AM CDT) owns this file. It audits all modules, reviews AWS/HashiCorp release notes, checks CIS/NIST benchmarks, and adds new backlog items or updates existing ones. It updates `Last reviewed` on every run.
- **Forge** (Jules, runs daily at 12:00 PM CDT) reads this file, picks the highest-priority `backlog` item, implements it, opens a PR, then marks the item `done` and records the PR number.
- Items move through statuses: `backlog` → `in-progress` → `done`.

### Backlog Item Format (Sentinel uses this template)

```
### <module-path>: <short title>

**Priority:** CRITICAL | HIGH | MEDIUM | LOW
**Type:** Security | Feature | Maintenance | Refactor
**Status:** `backlog` | `in-progress` | `done`
**Module:** aws/base_component/<name> or aws/workload_component/<name>
**Why:** <rationale>

#### Acceptance Criteria
- [ ] <criterion>
- [ ] <criterion>

#### Security Notes (if Type=Security)
- <note>
```

---

## Global Standards & Conventions

All modules in this repo MUST comply with these non-negotiable standards:

- **Tagging** — Accept and enforce a `tags` variable (map of strings). Required keys: `environment`, `owner`, `project`, `cost_center`.
- **No inline IAM policies** — IAM inline policies are forbidden. Use managed policy ARNs only.
- **CMK encryption** — All data-at-rest resources (S3, DynamoDB, RDS, EBS, Secrets Manager) must use a customer-managed KMS key (CMK). The module must create or accept the key ARN.
- **Least privilege** — IAM roles scoped to minimum required permissions. No `*` actions or resources unless explicitly justified in a comment.
- **VPC-first** — Compute resources (Lambda, RDS, EC2) must support VPC placement with configurable subnet IDs and security group IDs.
- **Versioned providers** — Each module must pin `required_providers` with a `~>` constraint and set a `required_version` for Terraform.
- **Outputs** — Every module must output at minimum: the primary resource ARN, resource ID/name, and any generated role/key ARNs.
- **Variable validation** — Use Terraform `validation` blocks for any variable with restricted allowed values.
- **Described everything** — All variables and outputs must have `description` fields. No exceptions.

---

## Module Backlog

---

### aws/base_component/iam: Opinionated IAM role module

**Priority:** CRITICAL
**Type:** Feature
**Status:** `backlog`
**Module:** aws/base_component/iam
**Why:** Foundational module — all other modules depend on this for execution roles and service principals. Enforces least-privilege patterns with managed policy attachments only.

#### Acceptance Criteria
- [ ] `aws_iam_role` created with configurable `assume_role_policy` (JSON string input)
- [ ] Variable `managed_policy_arns` (list of strings) — attaches each via `aws_iam_role_policy_attachment`
- [ ] Variable `permissions_boundary_arn` (optional string, default `null`) — attached when provided
- [ ] Variable `role_name` with validation: 1–64 chars, alphanumeric + `+=,.@_/-`
- [ ] Variable `managed_policy_arns` entries validated to match ARN format
- [ ] Required `tags` variable enforced (environment, owner, project, cost_center)
- [ ] Outputs: `role_arn`, `role_name`, `role_id`, `unique_id`
- [ ] `versions.tf` pins AWS provider `~> 5.0` and Terraform `>= 1.5`
- [ ] README with usage example, inputs table, outputs table
- [ ] At least one Terraform test: role created, policy attached, assume-role policy matches input

#### Security Notes
- Permissions boundary is strongly recommended for developer-facing roles
- No inline policies — by design

---

### aws/base_component/s3: Opinionated S3 bucket with CMK encryption

**Priority:** CRITICAL
**Type:** Feature
**Status:** `backlog`
**Module:** aws/base_component/s3
**Why:** S3 is the most widely used storage primitive. Auto-enforcing CMK encryption, public access blocking, versioning, and TLS-only access eliminates entire classes of data exposure risk.

#### Acceptance Criteria
- [ ] `aws_s3_bucket` with configurable `bucket_name` or name prefix
- [ ] `aws_kms_key` created automatically (or accept `existing_kms_key_arn`) used for SSE-KMS
- [ ] `aws_s3_bucket_server_side_encryption_configuration` using CMK
- [ ] `aws_s3_bucket_public_access_block` — all 4 block settings `true` by default
- [ ] `aws_s3_bucket_versioning` — `enabled` by default, variable to disable
- [ ] `aws_s3_bucket_ownership_controls` set to `BucketOwnerEnforced` (no ACLs)
- [ ] `aws_s3_bucket_policy` enforcing `aws:SecureTransport` (deny HTTP)
- [ ] Variable `lifecycle_rules` (optional) for object expiry/transition
- [ ] Variable `enable_access_logging` + `log_bucket_id` for server access logs
- [ ] `force_destroy` variable defaults to `false`
- [ ] Outputs: `bucket_id`, `bucket_arn`, `kms_key_arn`, `kms_key_id`
- [ ] Required `tags` enforced
- [ ] At least one Terraform test: bucket created, encryption confirmed, public access blocked

#### Security Notes
- Never set `force_destroy = true` by default
- Bucket policy must deny non-TLS requests
- Use `aws_s3_bucket_ownership_controls` not ACLs (ACLs deprecated)

---

### aws/base_component/lambda: Opinionated Lambda function module

**Priority:** HIGH
**Type:** Feature
**Status:** `backlog`
**Module:** aws/base_component/lambda
**Why:** Lambda is the primary compute primitive. Centralizing execution role creation, VPC config, CMK env var encryption, X-Ray tracing, and CW log groups prevents recurring security gaps across workload modules.

#### Acceptance Criteria
- [ ] `aws_lambda_function` with configurable runtime, handler, memory, timeout
- [ ] Execution role created via `aws/base_component/iam` module (or accept `existing_role_arn`)
- [ ] `aws_cloudwatch_log_group` with configurable `retention_in_days` (default: 30)
- [ ] X-Ray `tracing_config` set to `Active` by default
- [ ] Variable `vpc_config` (optional): `subnet_ids`, `security_group_ids`
- [ ] KMS key for environment variable encryption (`kms_key_arn` input or auto-create)
- [ ] `dead_letter_config` — optional SQS ARN or SNS ARN input
- [ ] Reserved concurrency variable (default `-1` = unreserved)
- [ ] Outputs: `function_arn`, `function_name`, `role_arn`, `invoke_arn`, `log_group_name`
- [ ] Required `tags` enforced
- [ ] At least one Terraform test: function deploys, log group exists, X-Ray enabled

#### Security Notes
- No hardcoded secrets in environment variables — require SSM/Secrets Manager references
- All non-public workloads must use VPC placement

---

### aws/workload_component/apigw_lambda: API Gateway v2 + Lambda pattern

**Priority:** HIGH
**Type:** Feature
**Status:** `backlog`
**Module:** aws/workload_component/apigw_lambda
**Why:** The most common serverless pattern in the org. Composing this from base modules eliminates the need for developers to wire up routes, integrations, stages, and Lambda permissions separately.

#### Acceptance Criteria
- [ ] Uses `aws/base_component/lambda` module internally (not raw `aws_lambda_function`)
- [ ] `aws_apigatewayv2_api` (HTTP API type)
- [ ] `aws_apigatewayv2_integration` linked to Lambda function ARN
- [ ] `aws_apigatewayv2_route` with configurable route key (e.g., `POST /items`)
- [ ] `aws_apigatewayv2_stage` with `auto_deploy = true` and CloudWatch access log group
- [ ] `aws_lambda_permission` granting API GW invoke rights
- [ ] Optional JWT authorizer: `aws_apigatewayv2_authorizer` with configurable `issuer` and `audience`
- [ ] Outputs: `api_endpoint`, `api_id`, `stage_id`, `route_id`, `function_arn`
- [ ] Required `tags` enforced
- [ ] At least one Terraform test: endpoint returns expected HTTP response

#### Security Notes
- JWT authorizer required for any non-public route — make this the default
- CloudWatch access logging must be enabled by default

---

## Security & Compliance Backlog

| ID | Item | Priority | Status |
|----|------|----------|--------|
| SEC-001 | All modules: enforce KMS CMK for at-rest encryption | CRITICAL | `backlog` |
| SEC-002 | S3: deny HTTP bucket policy (aws:SecureTransport) | CRITICAL | `backlog` |
| SEC-003 | IAM: permissions boundary variable support | CRITICAL | `backlog` |
| SEC-004 | Lambda: VPC placement variables | HIGH | `backlog` |
| SEC-005 | All modules: required tags validation block | CRITICAL | `backlog` |
| SEC-006 | Lambda: X-Ray tracing enabled by default | HIGH | `backlog` |
| SEC-007 | Review CIS AWS Foundations Benchmark v3.0 for gaps | MEDIUM | `backlog` |
| SEC-008 | S3: ownership controls (BucketOwnerEnforced, no ACLs) | HIGH | `backlog` |

---

## Provider & Deprecation Watch

| Item | Notes | Action Needed |
|------|-------|---------------|
| AWS Provider 5.x | Breaking changes from 4.x | All modules must use `~> 5.0` |
| `aws_s3_bucket` sub-resources | ACLs deprecated | Use `aws_s3_bucket_ownership_controls` |
| Terraform 1.6+ test framework | Native `terraform test` available | Evaluate for all new modules |
| `aws_lambda_function` `filename` vs S3 | S3 source recommended for prod | Document in module README |

---

## Future Module Ideas

- `aws/base_component/kms` — Standalone CMK module for cross-module key sharing
- `aws/base_component/rds` — RDS Postgres with CMK, Multi-AZ, subnet group
- `aws/base_component/secrets_manager` — Secret with CMK + rotation config
- `aws/base_component/vpc` — VPC with public/private subnets, flow logs, NAT gateway
- `aws/workload_component/ecs_fargate_service` — ECS Fargate + ALB + IAM role
- `aws/workload_component/eventbridge_lambda` — EventBridge rule → Lambda pattern
- `aws/workload_component/s3_lambda_trigger` — S3 event notification → Lambda
- `gcp/base_component/gcs` — (Future) GCP Cloud Storage equivalent
- `azure/base_component/storage` — (Future) Azure Blob Storage equivalent

---

## Changelog

| Date | Author | Change |
|------|--------|--------|
| 2026-04-18 | Human | Initial backlog with aligned CRITICAL/HIGH/MEDIUM/LOW priorities and standardized item format |
