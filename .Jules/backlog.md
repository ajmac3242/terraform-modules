# Terraform Modules — Product Backlog

> **Maintained by:** Sentinel (nightly) + Forge (marks items done)
> **Last reviewed:** 2026-04-20
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
**Status:** `done` (PR #2)
**Module:** aws/base_component/iam
**Why:** Foundational module — all other modules depend on this for execution roles and service principals. Enforces least-privilege patterns with managed policy attachments only.

#### Acceptance Criteria
- [x] `aws_iam_role` created with configurable `assume_role_policy` (JSON string input)
- [x] Variable `managed_policy_arns` (list of strings) — attaches each via `aws_iam_role_policy_attachment`
- [x] Variable `permissions_boundary_arn` (optional string, default `null`) — attached when provided
- [x] Variable `role_name` with validation: 1–64 chars, alphanumeric + `+=,.@_/-`
- [x] Variable `managed_policy_arns` entries validated to match ARN format
- [x] Required `tags` variable enforced (environment, owner, project, cost_center)
- [x] Outputs: `role_arn`, `role_name`, `role_id`, `unique_id`
- [x] `versions.tf` pins AWS provider `~> 5.0` and Terraform `>= 1.5`
- [x] README with usage example, inputs table, outputs table
- [x] At least one Terraform test: role created, policy attached, assume-role policy matches input

#### Security Notes
- Permissions boundary is strongly recommended for developer-facing roles
- No inline policies — by design

---

### aws/base_component/kms: Opinionated KMS Customer Managed Key module

**Priority:** CRITICAL
**Type:** Feature
**Status:** `done` (PR #1)
**Module:** aws/base_component/kms
**Why:** Foundational module — S3, Lambda, DynamoDB, RDS, and Secrets Manager all require a CMK for at-rest encryption. Centralizing key creation, rotation, deletion window, and least-privilege key policy prevents ad-hoc key sprawl and enforces a consistent encryption posture across the org.

#### Acceptance Criteria

- [x] `aws_kms_key` with `enable_key_rotation = true` by default
- [x] `deletion_window_in_days` variable (default: 30, validation: 7-30)
- [x] `aws_kms_alias` created automatically using `alias/var.name`
- [x] `key_policy` — supports configurable `admin_principal_arns` (list) and `usage_principal_arns` (list)
- [x] Key policy denies all access if no principal is specified (deny-by-default)
- [x] Variable `multi_region` (bool, default: `false`)
- [x] Outputs: `key_arn`, `key_id`, `alias_arn`, `alias_name`
- [x] Required `tags` enforced (environment, owner, project, cost_center)
- [x] `versions.tf` pins AWS provider `~> 5.0` and Terraform `>= 1.5`
- [x] README with usage example, inputs table, outputs table
- [x] At least one Terraform test: key created, rotation enabled, alias exists

#### Security Notes

- Key rotation must be enabled — no override to disable
- Least-privilege key policy: separate admin and usage principals
- Never use `"*"` as a principal in the key policy

---

### aws/base_component/s3: Opinionated S3 bucket with CMK encryption

**Priority:** CRITICAL
**Type:** Feature
**Status:** `done` (PR #3)
**Module:** aws/base_component/s3
**Why:** S3 is the most widely used storage primitive. Auto-enforcing CMK encryption, public access blocking, versioning, and TLS-only access eliminates entire classes of data exposure risk.

#### Acceptance Criteria
- [x] `aws_s3_bucket` with configurable `bucket_name` or name prefix
- [x] `aws_kms_key` created automatically (or accept `existing_kms_key_arn`) used for SSE-KMS
- [x] `aws_s3_bucket_server_side_encryption_configuration` using CMK
- [x] `aws_s3_bucket_public_access_block` — all 4 block settings `true` by default
- [x] `aws_s3_bucket_versioning` — `enabled` by default, variable to disable
- [x] `aws_s3_bucket_ownership_controls` set to `BucketOwnerEnforced` (no ACLs)
- [x] `aws_s3_bucket_policy` enforcing `aws:SecureTransport` (deny HTTP)
- [x] Variable `lifecycle_rules` (optional) for object expiry/transition
- [x] Variable `enable_access_logging` + `log_bucket_id` for server access logs
- [x] `force_destroy` variable defaults to `false`
- [x] Outputs: `bucket_id`, `bucket_arn`, `kms_key_arn`, `kms_key_id`
- [x] Required `tags` enforced
- [x] At least one Terraform test: bucket created, encryption confirmed, public access blocked

#### Security Notes
- Never set `force_destroy = true` by default
- Bucket policy must deny non-TLS requests
- Use `aws_s3_bucket_ownership_controls` not ACLs (ACLs deprecated)

---

### aws/base_component/lambda: Opinionated Lambda function module

**Priority:** HIGH
**Type:** Feature
**Status:** `done` (PR #4)
**Module:** aws/base_component/lambda
**Why:** Lambda is the primary compute primitive. Centralizing execution role creation, VPC config, CMK env var encryption, X-Ray tracing, and CW log groups prevents recurring security gaps across workload modules.

#### Acceptance Criteria
- [x] `aws_lambda_function` with configurable runtime, handler, memory, timeout
- [x] Execution role created via `aws/base_component/iam` module (or accept `existing_role_arn`)
- [x] `aws_cloudwatch_log_group` with configurable `retention_in_days` (default: 30)
- [x] X-Ray `tracing_config` set to `Active` by default
- [x] Variable `vpc_config` (optional): `subnet_ids`, `security_group_ids`
- [x] KMS key for environment variable encryption (`kms_key_arn` input or auto-create)
- [x] `dead_letter_config` — optional SQS ARN or SNS ARN input
- [x] Reserved concurrency variable (default `-1` = unreserved)
- [x] Outputs: `function_arn`, `function_name`, `role_arn`, `invoke_arn`, `log_group_name`
- [x] Required `tags` enforced
- [x] At least one Terraform test: function deploys, log group exists, X-Ray enabled

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

### aws/base_component/vpc: Opinionated VPC module

**Priority:** CRITICAL
**Type:** Feature
**Status:** `done` (PR #5)
**Module:** aws/base_component/vpc
**Why:** Foundational networking module. Required for Fargate, RDS, and secure Lambda placement. Enforces flow logs and private-by-default subnetting.

#### Acceptance Criteria
- [x] VPC with configurable CIDR block
- [x] Public and Private subnets across multiple AZs
- [x] NAT Gateway (configurable: one per AZ, single, or none)
- [x] VPC Flow Logs enabled and sent to CloudWatch (encrypted)
- [x] Required `tags` enforced on VPC and all subnets
- [x] Outputs: `vpc_id`, `public_subnet_ids`, `private_subnet_ids`, `vpc_cidr_block`
- [x] Terraform test: VPC created with expected subnets and tags

---

### aws/base_component/dynamodb: Opinionated DynamoDB table module

**Priority:** HIGH
**Type:** Feature
**Status:** `done` (PR #5)
**Module:** aws/base_component/dynamodb
**Why:** Core NoSQL storage. Enforces CMK encryption and point-in-time recovery.

#### Acceptance Criteria
- [x] `aws_dynamodb_table` with configurable `hash_key`, `range_key`, and `attributes`
- [x] `billing_mode` defaults to `PAY_PER_REQUEST`
- [x] `server_side_encryption` using mandatory `kms_key_arn`
- [x] `point_in_time_recovery` enabled by default
- [x] Required `tags` enforced
- [x] Outputs: `table_arn`, `table_name`, `table_id`
- [x] Terraform test: Table created with PITR and CMK encryption

---

### aws/base_component/rds: Opinionated RDS instance module

**Priority:** HIGH
**Type:** Feature
**Status:** `done` (PR #5)
**Module:** aws/base_component/rds
**Why:** Core relational storage. Enforces CMK encryption, Multi-AZ for prod, and VPC placement.

#### Acceptance Criteria
- [x] `aws_db_instance` (Postgres/MySQL) with configurable engine, version, instance class
- [x] Mandatory `kms_key_id` for storage encryption
- [x] `multi_az` defaults to `true`
- [x] `storage_encrypted` must be `true`
- [x] Placed in VPC private subnets via `aws_db_subnet_group`
- [x] Required `tags` enforced
- [x] Outputs: `db_instance_arn`, `db_instance_endpoint`, `db_instance_id`
- [x] Terraform test: RDS instance created in private subnets with encryption

---

### aws/base_component/sqs: Opinionated SQS queue module

**Priority:** MEDIUM
**Type:** Feature
**Status:** `done` (PR #5)
**Module:** aws/base_component/sqs
**Why:** Core messaging primitive. Enforces CMK encryption.

#### Acceptance Criteria
- [x] `aws_sqs_queue` with configurable name and visibility timeout
- [x] Mandatory `kms_master_key_id` for encryption
- [x] `sqs_managed_sse_enabled` set to `false` (favor CMK)
- [x] Dead-letter queue support (configurable)
- [x] Required `tags` enforced
- [x] Outputs: `queue_arn`, `queue_url`, `queue_id`
- [x] Terraform test: Queue created with CMK encryption

---

### aws/base_component/ssm: Opinionated SSM Parameter module

**Priority:** MEDIUM
**Type:** Feature
**Status:** `done` (PR #5)
**Module:** aws/base_component/ssm
**Why:** Standard secret/config management. Enforces `SecureString` with CMK.

#### Acceptance Criteria
- [x] `aws_ssm_parameter` of type `SecureString`
- [x] Mandatory `key_id` (KMS CMK) for encryption
- [x] Required `tags` enforced
- [x] Outputs: `parameter_arn`, `parameter_name`
- [x] Terraform test: Parameter created as SecureString with CMK

---

### aws/workload_component/ecs_fargate: ECS Fargate Service pattern

**Priority:** HIGH
**Type:** Feature
**Status:** `done` (PR #5)
**Module:** aws/workload_component/ecs_fargate
**Why:** Common container compute pattern. Enforces VPC placement, Fargate launch type, and CMK encryption for logs.

#### Acceptance Criteria
- [x] `aws_ecs_cluster` and `aws_ecs_service`
- [x] Task definition with Fargate compatibility
- [x] Placed in VPC private subnets
- [x] Log group with KMS encryption (reuse `kms_key_arn`)
- [x] Task execution role and Task role via `aws/base_component/iam`
- [x] Required `tags` enforced
- [x] Outputs: `cluster_arn`, `service_arn`, `task_definition_arn`
- [x] Terraform test: Cluster and service created with Fargate capacity providers

---

### aws/base_component/cloudfront: Opinionated CloudFront distribution module

**Priority:** HIGH
**Type:** Feature
**Status:** `done` (PR #6)
**Module:** aws/base_component/cloudfront
**Why:** Secure content delivery. Enforces TLS 1.2+, WAF integration, and logging.

#### Acceptance Criteria
- [ ] `aws_cloudfront_distribution` with S3 or ALBy origin
- [ ] Mandatory WAF association
- [ ] Access logging to S3 enabled by default
- [ ] Minimum protocol version TLSv1.2_2021
- [ ] Required `tags` enforced
- [ ] Outputs: `distribution_id`, `distribution_arn`, `distribution_domain_name`

---

### aws/base_component/vpc_endpoints: Opinionated VPC Endpoints module

**Priority:** MEDIUM
**Type:** Feature
**Status:** `done` (PR #6)
**Module:** aws/base_component/vpc_endpoints
**Why:** Enables private access to AWS services without NAT gateways.

#### Acceptance Criteria
- [ ] Support for S3 and DynamoDB Gateway endpoints
- [ ] Support for Interface endpoints (e.g., kms, logs, execute-api)
- [ ] Security groups for interface endpoints scoped to VPC CIDR
- [ ] Required `tags` enforced
- [ ] Outputs: `s3_endpoint_id`, `dynamodb_endpoint_id`, `interface_endpoint_ids`

---

### aws/base_component/subnet: Standalone Subnet module

**Priority:** MEDIUM
**Type:** Feature
**Status:** `done` (PR #6)
**Module:** aws/base_component/subnet
**Why:** For custom network topologies where the standard VPC module is too rigid.

#### Acceptance Criteria
- [ ] `aws_subnet` with configurable CIDR and AZ
- [ ] `map_public_ip_on_launch` defaults to `false`
- [ ] Required `tags` enforced
- [ ] Outputs: `subnet_id`, `subnet_arn`

---

### aws/base_component/security_group: Opinionated Security Group module

**Priority:** MEDIUM
**Type:** Feature
**Status:** `done` (PR #6)
**Module:** aws/base_component/security_group
**Why:** Consistent SG management with mandatory descriptions and no 0.0.0.0/0 defaults.

#### Acceptance Criteria
- [ ] `aws_security_group` with mandatory `description`
- [ ] No default rules (must be explicitly provided)
- [ ] Validation: No `0.0.0.0/0` in ingress rules without override
- [ ] Required `tags` enforced
- [ ] Outputs: `security_group_id`, `security_group_arn`

---

### aws/base_component/sns: Opinionated SNS Topic module

**Priority:** MEDIUM
**Type:** Feature
**Status:** `done` (PR #6)
**Module:** aws/base_component/sns
**Why:** Core messaging component with enforced CMK encryption.

#### Acceptance Criteria
- [x] SNS Topic with mandatory KMS key
- [x] Required tags enforced
- [x] Terraform test provided

---

### aws/base_component/secrets_manager: Opinionated Secrets Manager module

**Priority:** HIGH
**Type:** Feature
**Status:** `done` (PR #6)
**Module:** aws/base_component/secrets_manager
**Why:** Secure storage of secrets with rotation support and CMK.

#### Acceptance Criteria
- [x] Secrets Manager secret with mandatory KMS key
- [x] Enforced 30-day recovery window
- [x] Required tags enforced
- [x] Terraform test provided

---

### aws/base_component/route53: Opinionated Route 53 module

**Priority:** MEDIUM
**Type:** Feature
**Status:** `done` (PR #6)
**Module:** aws/base_component/route53
**Why:** Managed DNS records with standard validation.

#### Acceptance Criteria
- [x] Route 53 records support
- [x] No unused tags variable (records don't support tags)
- [x] Terraform test provided

---

### aws/base_component/elasticache: Opinionated ElastiCache module

**Priority:** HIGH
**Type:** Feature
**Status:** `done` (PR #6)
**Module:** aws/base_component/elasticache
**Why:** Managed Redis with enforced CMK encryption and private networking.

#### Acceptance Criteria
- [x] Redis replication group (supports encryption)
- [x] Mandatory at-rest and transit encryption
- [x] Private subnet placement
- [x] Required tags enforced
- [x] Terraform test verified with string comparison

---

### aws/base_component/eks: Opinionated EKS module

**Priority:** CRITICAL
**Type:** Feature
**Status:** `done` (PR #6)
**Module:** aws/base_component/eks
**Why:** Managed Kubernetes with enforced secret encryption and IAM best practices.

#### Acceptance Criteria
- [x] EKS Cluster with mandatory CMK encryption for secrets
- [x] Cluster role created via base IAM module
- [x] Private subnet placement
- [x] Required tags enforced
- [x] Terraform test provided

---

## Future Module Ideas

- `aws/workload_component/eventbridge_lambda` — EventBridge rule → Lambda pattern
- `aws/workload_component/s3_lambda_trigger` — S3 event notification → Lambda
- `gcp/base_component/gcs` — (Future) GCP Cloud Storage equivalent
- `azure/base_component/storage` — (Future) Azure Blob Storage equivalent

---

## Changelog

| Date | Author | Change |
|------|--------|--------|
| 2026-04-18 | Human | Initial backlog with aligned CRITICAL/HIGH/MEDIUM/LOW priorities and standardized item format |
| 2026-04-20 | Sentinel | Nightly audit; updated KMS deletion window requirement |
