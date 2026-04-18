# Terraform Modules — Product Backlog

> **Maintained by:** Backlog Curator (Jules)
> **Last reviewed:** <!-- Jules will update this on each run -->
> **Purpose:** Single source of truth for all module requirements, acceptance criteria, security standards, and feature requests across this multi-cloud Terraform module registry.

---

## How This File Works

- The **Backlog Curator** (Jules scheduled task) owns this file. It periodically reviews AWS provider release notes, HashiCorp deprecation notices, CIS/NIST benchmarks, and internal patterns to add new backlog items and update existing ones.
- The **Developer** (Jules scheduled task) reads this file to understand exactly what to build, then implements the Terraform code, writes tests, and opens PRs.
- Items move through statuses: `backlog` → `in-progress` → `done`.

---

## Global Standards & Conventions

All modules in this repo MUST:

- **Tagging** — Accept and enforce a `tags` variable (map of strings). Required keys: `environment`, `owner`, `project`, `cost_center`.
- **No inline policies** — IAM inline policies are forbidden. Use managed policy ARNs only.
- **CMK encryption** — All data-at-rest resources (S3, DynamoDB, RDS, EBS, Secrets Manager, etc.) must use a customer-managed KMS key (CMK). The module must create or accept the key ARN.
- **Least privilege** — IAM roles scoped to minimum required permissions. No `*` actions or resources unless explicitly justified in a comment.
- **VPC-first** — Compute resources (Lambda, RDS, EC2) must support VPC placement with configurable subnet IDs and security group IDs.
- **Versioned providers** — Each module directory must pin `required_providers` with a `~>` constraint.
- **Outputs** — Every module must output at minimum: the primary resource ARN, resource ID/name, and any generated role/key ARNs.
- **Variable validation** — Use Terraform `validation` blocks for any variable with restricted allowed values.
- **Terraform docs** — All variables and outputs documented with `description` fields. README auto-generated format from `terraform-docs`.

---

## Module Backlog

---

### `aws/base_component/iam`

**Status:** `backlog`
**Priority:** P0 — Foundational (all other modules depend on this)

#### Description
Opinionated IAM role module. Creates an IAM role with a configurable assume-role policy, attaches a list of managed policy ARNs, and optionally sets a permissions boundary. No inline policies by design.

#### Acceptance Criteria
- [ ] `aws_iam_role` created with configurable `assume_role_policy` (JSON string input)
- [ ] Variable `managed_policy_arns` (list of strings) — attaches each via `aws_iam_role_policy_attachment`
- [ ] Variable `permissions_boundary_arn` (optional string, default `null`) — attached when provided
- [ ] Variable `role_name` with validation: 1–64 chars, alphanumeric + `+=,.@_/-`
- [ ] Required `tags` variable enforced (environment, owner, project, cost_center)
- [ ] Outputs: `role_arn`, `role_name`, `role_id`, `unique_id`
- [ ] Unit test (Terratest or native Terraform test): role is created, policy is attached, assume-role policy matches input
- [ ] README generated via terraform-docs

#### Security Notes
- Permissions boundary is strongly recommended for developer-facing roles
- Validate that `managed_policy_arns` entries match ARN format (`arn:aws:iam::*`)

---

### `aws/base_component/s3`

**Status:** `backlog`
**Priority:** P0 — Foundational

#### Description
Opinionated S3 bucket module. Automatically creates and attaches a CMK (KMS key) for server-side encryption. Enforces secure transport, blocks public access, and enables versioning by default.

#### Acceptance Criteria
- [ ] `aws_s3_bucket` with configurable `bucket_name` (or name prefix)
- [ ] `aws_kms_key` created automatically (or accept `existing_kms_key_arn`) — used for SSE-KMS
- [ ] `aws_s3_bucket_server_side_encryption_configuration` using CMK
- [ ] `aws_s3_bucket_public_access_block` — all 4 block settings `true` by default
- [ ] `aws_s3_bucket_versioning` — `enabled` by default, variable to disable
- [ ] `aws_s3_bucket_policy` enforcing `aws:SecureTransport` (HTTPS only)
- [ ] Variable `lifecycle_rules` (optional) for object expiry/transition
- [ ] Variable `enable_access_logging` + `log_bucket_id` for server access logs
- [ ] Outputs: `bucket_id`, `bucket_arn`, `kms_key_arn`, `kms_key_id`
- [ ] Required `tags` enforced
- [ ] Terratest: bucket created, encryption confirmed, public access blocked

#### Security Notes
- Never set `force_destroy = true` by default — variable default must be `false`
- Bucket policy must deny non-TLS requests

---

### `aws/base_component/lambda`

**Status:** `backlog`
**Priority:** P1

#### Description
Opinionated Lambda function module. Handles function creation, IAM execution role (via `aws/base_component/iam`), VPC config, environment variable encryption via CMK, and optional dead-letter queue.

#### Acceptance Criteria
- [ ] `aws_lambda_function` with configurable runtime, handler, memory, timeout
- [ ] Execution role created via `aws/base_component/iam` module (or accept `existing_role_arn`)
- [ ] Variable `vpc_config` (optional): `subnet_ids`, `security_group_ids`
- [ ] KMS key for environment variable encryption (`kms_key_arn` input or auto-create)
- [ ] `dead_letter_config` — optional SQS ARN or SNS ARN input
- [ ] `aws_lambda_function_event_invoke_config` for retry behavior
- [ ] Reserved concurrency variable (default `-1` = unreserved)
- [ ] Outputs: `function_arn`, `function_name`, `role_arn`, `invoke_arn`
- [ ] Required `tags` enforced
- [ ] Terratest: function deploys, invoker returns expected response

#### Security Notes
- All Lambda functions must be VPC-attached for non-public workloads
- No hardcoded environment variable secrets — require SSM/Secrets Manager references

---

### `aws/workload_component/apigw_lambda`

**Status:** `backlog`
**Priority:** P1

#### Description
Combined API Gateway v2 (HTTP API) + Lambda integration. Eliminates the need for developers to wire up the route, integration, stage, and permissions separately. Opinionated defaults: auto-deploy enabled, JWT authorizer support, access logging to CloudWatch.

#### Acceptance Criteria
- [ ] `aws_apigatewayv2_api` (HTTP API type)
- [ ] `aws_apigatewayv2_integration` linked to Lambda function ARN input
- [ ] `aws_apigatewayv2_route` with configurable route key (e.g., `POST /items`)
- [ ] `aws_apigatewayv2_stage` with `auto_deploy = true` and access log group
- [ ] `aws_lambda_permission` granting API GW invoke rights
- [ ] Optional JWT authorizer: `aws_apigatewayv2_authorizer` with configurable `issuer` and `audience`
- [ ] Outputs: `api_endpoint`, `api_id`, `stage_id`, `route_id`
- [ ] Required `tags` enforced
- [ ] Terratest: endpoint returns expected HTTP response

#### Security Notes
- Default stage should not be `$default` without auth — JWT authorizer required for any non-public route
- Enable CloudWatch access logging by default

---

## Security & Compliance Backlog

| ID | Item | Priority | Status |
|----|------|----------|--------|
| SEC-001 | All modules: enforce KMS CMK for at-rest encryption | P0 | `backlog` |
| SEC-002 | S3: deny HTTP (non-TLS) bucket policy | P0 | `backlog` |
| SEC-003 | IAM: permissions boundary support | P0 | `backlog` |
| SEC-004 | Lambda: VPC placement variables | P1 | `backlog` |
| SEC-005 | All modules: required tags validation | P0 | `backlog` |
| SEC-006 | Review CIS AWS Foundations Benchmark v2.0 for gaps | P1 | `backlog` |

---

## Provider & Deprecation Watch

| Item | Notes | Action Needed |
|------|-------|---------------|
| AWS Provider 5.x migration | Breaking changes from 4.x | Verify all resources use 5.x syntax |
| `aws_s3_bucket` sub-resources | Bucket ACLs deprecated in favor of ownership controls | Use `aws_s3_bucket_ownership_controls` |
| Terraform 1.6+ test framework | Native `terraform test` replaces some Terratest patterns | Evaluate for new modules |

---

## Future Module Ideas

- `aws/base_component/kms` — Standalone CMK module for cross-module key sharing
- `aws/base_component/rds` — RDS Postgres with CMK, Multi-AZ, subnet group
- `aws/base_component/secrets_manager` — Secret with CMK, rotation config
- `aws/workload_component/ecs_fargate_service` — ECS Fargate + ALB + IAM role
- `aws/workload_component/eventbridge_lambda` — EventBridge rule → Lambda pattern
- `gcp/base_component/gcs` — (Future) GCP equivalent of S3 module
- `azure/base_component/storage` — (Future) Azure Blob storage equivalent

---

## Changelog

| Date | Author | Change |
|------|--------|--------|
| <!-- Jules inserts date --> | Backlog Curator (Jules) | Initial backlog created |
