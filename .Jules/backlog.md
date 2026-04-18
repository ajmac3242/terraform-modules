# Module Backlog

This is the shared source of truth for all work items in this repository. It is read and updated by:
- **Sentinel** 🛡️ — adds security findings and compliance violations nightly
- **Forge** 🔨 — picks items to implement daily at noon, marks them `[DONE]`
- **You** — add items anytime using the template below

---

## Template

```
## <Issue Title>
**Priority:** CRITICAL | HIGH | MEDIUM | LOW
**Type:** Security | Feature | Enhancement | Docs | Bug
**Module:** aws/base_component/<name> or aws/workload_component/<name>
**Added by:** Sentinel | Forge | Human
**Status:** TODO | IN PROGRESS | DONE (PR #<number>)
**Why:** <why this matters — security risk, developer pain, consistency gap>
**What:** <what needs to be built or changed>
**Acceptance Criteria:**
- [ ] <specific, testable criterion>
- [ ] <specific, testable criterion>
```

---

## Backlog Items

## Create aws/base_component/kms module
**Priority:** HIGH
**Type:** Feature
**Module:** aws/base_component/kms
**Added by:** Human
**Status:** TODO
**Why:** KMS is a dependency of S3 (CMK encryption) and Lambda (env var encryption). It must exist as a standalone base component before those modules can be built correctly.
**What:** Create a KMS Customer Managed Key (CMK) module that other modules can source as a dependency.
**Acceptance Criteria:**
- [ ] Creates an `aws_kms_key` resource with configurable description and tags
- [ ] Key rotation enabled by default (`enable_key_rotation = true`)
- [ ] Deletion window variable with default of 30 days, minimum enforcement of 7 days
- [ ] Creates an `aws_kms_alias` resource
- [ ] Key policy supports configurable admin and usage principals via variables
- [ ] Key policy denies all access if no principal is specified (deny-by-default posture)
- [ ] All variables have `description` and `type`
- [ ] All outputs have `description` (exports: key_id, key_arn, key_alias_arn)
- [ ] Required tags variable applied to key resource
- [ ] `versions.tf` pins aws provider `>= 5.0` and terraform `>= 1.5`
- [ ] `README.md` includes usage example and inputs/outputs tables

---

## Create aws/base_component/s3 module
**Priority:** HIGH
**Type:** Feature
**Module:** aws/base_component/s3
**Added by:** Human
**Status:** TODO
**Why:** S3 is one of the most commonly misconfigured AWS services. This module must enforce CMK encryption, public access blocking, versioning, and access logging so developers never have to think about it.
**What:** Create an opinionated S3 bucket module with all security defaults enforced.
**Acceptance Criteria:**
- [ ] Creates an `aws_s3_bucket` resource
- [ ] CMK KMS key encryption enforced via `aws_s3_bucket_server_side_encryption_configuration` — uses the `aws/base_component/kms` module or accepts a `kms_key_arn` variable
- [ ] Public access blocked on all 4 settings (`block_public_acls`, `block_public_policy`, `ignore_public_acls`, `restrict_public_buckets`)
- [ ] Versioning enabled by default, configurable via variable
- [ ] Access logging configured to a separate logging bucket (accept `logging_bucket` variable)
- [ ] Bucket policy enforces SSL-only access (`aws:SecureTransport` condition)
- [ ] Lifecycle rules variable for configurable object expiration and transition
- [ ] All variables have `description` and `type`
- [ ] All outputs have `description` (exports: bucket_id, bucket_arn, bucket_domain_name)
- [ ] Required tags variable applied
- [ ] `versions.tf` pins aws provider `>= 5.0` and terraform `>= 1.5`
- [ ] `README.md` includes usage example and inputs/outputs tables

---

## Create aws/base_component/iam module
**Priority:** HIGH
**Type:** Feature
**Module:** aws/base_component/iam
**Added by:** Human
**Status:** TODO
**Why:** IAM roles and policies are used by Lambda, ECS, and other services. A base IAM module enforces least-privilege patterns and prevents inline policy usage across all consumers.
**What:** Create a reusable IAM role module with assume-role policy and configurable managed/inline policy attachments.
**Acceptance Criteria:**
- [ ] Creates an `aws_iam_role` with configurable `assume_role_policy` (passed as variable)
- [ ] Attaches a list of managed policy ARNs via `aws_iam_role_policy_attachment`
- [ ] No inline policies created by the module itself
- [ ] Role name and description configurable via variables
- [ ] Permission boundary variable (optional, but supported)
- [ ] All variables have `description` and `type`
- [ ] All outputs have `description` (exports: role_arn, role_name, role_id)
- [ ] Required tags applied to role
- [ ] `versions.tf` pins aws provider `>= 5.0` and terraform `>= 1.5`
- [ ] `README.md` includes usage example and inputs/outputs tables

---

## Create aws/base_component/lambda module
**Priority:** HIGH
**Type:** Feature
**Module:** aws/base_component/lambda
**Added by:** Human
**Status:** TODO
**Why:** Lambda is a core compute primitive. This module must enforce CloudWatch logging with retention, X-Ray tracing, and a least-privilege execution role so developers get these for free.
**What:** Create an opinionated Lambda function module with logging, tracing, and IAM baked in.
**Acceptance Criteria:**
- [ ] Creates an `aws_lambda_function` resource
- [ ] Creates a `aws_cloudwatch_log_group` with configurable retention (default 14 days)
- [ ] X-Ray tracing enabled (`tracing_config { mode = "Active" }`)
- [ ] Creates a least-privilege `aws_iam_role` for execution using the `aws/base_component/iam` module or inline
- [ ] IAM role has `AWSLambdaBasicExecutionRole` attached; additional policy ARNs accepted via variable
- [ ] Reserved concurrency variable (default `-1` for unreserved, but documented)
- [ ] Environment variables map accepted as variable (optional)
- [ ] KMS key ARN variable for environment variable encryption (optional, but documented)
- [ ] All variables have `description` and `type`
- [ ] All outputs have `description` (exports: function_arn, function_name, invoke_arn, role_arn)
- [ ] Required tags applied
- [ ] `versions.tf` pins aws provider `>= 5.0` and terraform `>= 1.5`
- [ ] `README.md` includes usage example and inputs/outputs tables

---

## Create aws/base_component/vpc module
**Priority:** MEDIUM
**Type:** Feature
**Module:** aws/base_component/vpc
**Added by:** Human
**Status:** TODO
**Why:** VPCs are foundational network infrastructure. Flow logs, proper subnet segmentation, and no unrestricted inbound access must be enforced.
**What:** Create an opinionated VPC module using terraform-aws-modules/vpc with flow logs and secure defaults.
**Acceptance Criteria:**
- [ ] Sources from `terraform-aws-modules/vpc/aws` registry module
- [ ] VPC flow logs enabled and publishing to CloudWatch Logs with configurable retention
- [ ] Separate public/private/intra subnet CIDR variables
- [ ] NAT gateway configurable (single or per-AZ)
- [ ] No default security group rules (deny all by default)
- [ ] DNS hostnames and resolution enabled by default
- [ ] All variables have `description` and `type`
- [ ] All outputs have `description` (exports: vpc_id, private_subnet_ids, public_subnet_ids, vpc_cidr_block)
- [ ] Required tags applied
- [ ] `versions.tf` pins aws provider `>= 5.0` and terraform `>= 1.5`
- [ ] `README.md` includes usage example and inputs/outputs tables

---

## Create aws/workload_component/api_gateway_lambda module
**Priority:** MEDIUM
**Type:** Feature
**Module:** aws/workload_component/api_gateway_lambda
**Added by:** Human
**Status:** TODO
**Why:** API Gateway + Lambda is one of the most common serverless patterns. Combining them into one module saves developers significant boilerplate and ensures auth, logging, and CORS are configured correctly every time.
**What:** Create a composed workload module that wires API Gateway HTTP API to a Lambda function with logging, auth, and CORS.
**Acceptance Criteria:**
- [ ] Calls `aws/base_component/lambda` module (does NOT duplicate Lambda resources)
- [ ] Creates an `aws_apigatewayv2_api` (HTTP API, not REST API)
- [ ] Creates an `aws_apigatewayv2_stage` with access logging to CloudWatch
- [ ] Creates an `aws_apigatewayv2_integration` for Lambda proxy integration
- [ ] Creates one or more `aws_apigatewayv2_route` resources (configurable via variable)
- [ ] Lambda permission for API Gateway to invoke (`aws_lambda_permission`)
- [ ] CORS configuration variable (optional, but supported)
- [ ] Auth variable for JWT authorizer (optional: accepts issuer and audience)
- [ ] All variables have `description` and `type`
- [ ] All outputs have `description` (exports: api_endpoint, api_id, lambda_function_arn)
- [ ] Required tags applied
- [ ] `versions.tf` pins aws provider `>= 5.0` and terraform `>= 1.5`
- [ ] `README.md` includes end-to-end usage example

---

<!-- Sentinel and Forge will add new items above this line -->
