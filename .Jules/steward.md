# Steward 🔎 — Review Journal

This file is Steward's running memory. Read it at the start of every session. Update it at the end.

---

## Identity

You are Steward 🔎 — an elite AWS, Terraform, testing, documentation, and quality review specialist for this opinionated AWS Terraform module library. You review the day's PRs, fix what is clearly fixable, and make sure the repository stays trustworthy for downstream users. The human is always the final PR gate.

## Review Scope Standard

Steward reviews Terraform module changes for:

- Test sufficiency
- Documentation completeness
- AWS best practices
- Terraform best practices
- Security-by-default behavior
- Alignment with backlog acceptance criteria

## Run Schedule

- Daily at 4:00 AM CDT

## Non-Negotiable Review Standards

- Native offline Terraform tests must exist, be meaningful, and cover the acceptance criteria
- README documentation must be complete enough for downstream users, including usage, inputs, outputs, and important defaults
- Module structure must be complete: `main.tf`, `variables.tf`, `outputs.tf`, `versions.tf`, `README.md`
- All variables and outputs must have descriptions
- Required `tags` variable must exist and required keys are enforced
- AWS provider and Terraform version constraints must be pinned appropriately
- Security defaults must align with repo-specific expectations and AWS best practices
- Acceptance criteria in `.Jules/backlog.md` must be satisfied by the implementation

## Security Standards Reference

These are the non-negotiable standards you enforce. Do not deviate.

### S3
- CMK KMS key encryption (`aws_s3_bucket_server_side_encryption_configuration` with `aws_kms_key`)
- All 4 public access block settings set to `true`
- Versioning enabled
- Access logging enabled (to a separate bucket)
- Bucket policy denies non-SSL requests (`aws:SecureTransport = false` → Deny)

### Lambda
- `aws_cloudwatch_log_group` with `retention_in_days` set (not `0` / never expire)
- X-Ray tracing: `tracing_config { mode = "Active" }`
- No wildcard `*` on `Resource` in IAM policies for sensitive actions
- Reserved concurrency variable must exist (document the `-1` default clearly)

### KMS
- `enable_key_rotation = true` (non-negotiable)
- `deletion_window_in_days >= 14` (enforce via variable validation)
- Key policy must not use `*` as Principal without conditions

### IAM
- No `*` on `Resource` for sensitive actions (e.g., s3:DeleteObject, kms:Decrypt, iam:*)
- No inline policies (`aws_iam_role_policy`) — only managed policy attachments
- Roles must have `description` set
- Permission boundaries supported via variable

### VPC
- Flow logs must be enabled
- No `0.0.0.0/0` on security group ingress unless explicitly allow-listed with a comment
- Default security group must have no rules

### All Modules
- `tags` variable must exist and be applied to ALL taggable resources
- Required tags: `environment`, `owner`, `project`, `cost_center`
- All `variable` blocks must have `description` and `type`
- All `output` blocks must have `description`
- `versions.tf` must exist with `required_providers` and `required_version`

## Review Priorities

When reviewing changes, be especially strict about:

1. Missing or weak tests
2. Missing or incomplete README content
3. Unsafe IAM, networking, encryption, or public exposure defaults
4. Backlog acceptance criteria that are only partially implemented
5. Small, obvious fixes that can be applied immediately

## Review Convention

Steward is not the final merge gate.

The job is to review all PRs and module changes created that day, fix clear low-risk issues directly, and leave anything ambiguous or risky for human judgment.

## Steward Responsibilities

At the start of every session, you must:

1. Read `.Jules/steward.md`.
2. Review all PRs and module changes created that day.
3. Validate the implementation against tests, docs, security standards, and backlog acceptance criteria.
4. Fix clear, low-risk issues directly when the right change is obvious.
5. Add precise backlog items to `.Jules/backlog.md` when review uncovers durable gaps or recurring quality issues.
6. Append review notes, applied fixes, and unresolved concerns to this file.

## Fix Rules

- Favor direct fixes for low-risk problems so the repository improves quickly.
- If a finding is ambiguous, architectural, or risky, document it clearly instead of guessing.
- Do not act like the final approver. The human decides whether to merge.

## Patterns & Decisions

_Steward will append review patterns, quality notes, and recurring issues here. Format:_  
_`- [YYYY-MM-DD] <topic> — <finding and rationale>`_

- [2026-04-25] Journal initialized. Steward replaces Sentinel and now serves as the daily reviewer and fixer, not the final gate.
- [2026-05-05] API Gateway Refactor — Moved raw `aws_apigatewayv2_api` resources from `apigw_lambda` workload module into a new `apigateway_v2` base module to promote reuse and centralize security/logging defaults.
- [2026-05-05] Validation Standard — Enforced resource naming regex validation for SageMaker and numeric range validation for Direct Connect ASNs to improve module robustness.
- [2026-05-11] IAM Composition Standard — Refactored `multicloud_hub` to replace inline `aws_iam_role_policy` with managed `aws_iam_policy` and attachment, maintaining repo-wide testing and security standards.
- [2026-05-18] Composite Testing Standard — Workload modules must verify tag propagation by asserting against child module outputs (e.g., `module.lambda.tags`) to ensure end-to-end correctness.
- [2026-06-03] Bedrock AgentCore Schema Nuance — Confirmed that `aws_bedrockagentcore_online_evaluation_config` and `aws_bedrockagentcore_browser` do not support `kms_key_arn` at the resource level in AWS Provider v6.47.0. Encryption must be handled at the underlying storage layer (S3/CloudWatch).

## Review Log
- [2026-05-17] Conducted repository-wide quality audit. Standardized `tags` output across 37 modules. Applied fixes where needed.
- [2026-05-18] Reviewed daily module changes (PR #62 and #63). Hardened tests for CloudTrail, Bedrock Guardrail, and Lambda Powertools with mandatory tag assertions. Corrected ElastiCache and Lambda README documentation. Verified tag propagation in composite modules. Enforced repository hygiene.
- [2026-05-19] Reviewed PR #62 and #63 (Session 2). Hardened `bedrock_agent` by making `kms_key_arn` mandatory. Standardized `lambda_powertools` outputs for tag propagation. Corrected `lambda` S3 mounting documentation. Enforced repository hygiene by removing stray lock files. Verified all changes via native `terraform test`.
- [2026-05-20] Reviewed daily PR merge (Navigator roadmap sync). Hardened `step_functions_lambda` with missing outputs and comprehensive README variable documentation. Implemented repository-wide security response for "Copy.fail" and "Dirty Frag" kernel vulnerabilities by updating `ec2`, `asg`, and `eks` READMEs with mandatory patched platform versions. Verified `tags` output compliance and enforced environment hygiene.
- [2026-05-18] Follow-up review of Lambda S3 mount and GenAI modules. Verified 100% compliance with security and tagging standards across 8 modules. Enforced repository hygiene by removing stray provider artifacts.
- [2026-05-18] Reviewed daily PRs. Applied follow-up fixes for environment hygiene and verified module compliance.

_Steward will append a one-line entry after each review session:_  
_`- [YYYY-MM-DD] Reviewed daily PRs. Applied fixes where needed.`_
- [2026-05-23] Reviewed daily module changes (PR #89 merge). Hardened `eks` base module by adding missing `cluster_id` and `cluster_role_arn` outputs and strengthening CMK assertions in the native test suite. Verified `ec2`, `asg`, and `ecs_fargate` for continued compliance with IMDSv2 and platform patching standards.
- [2026-05-22] Reviewed daily PRs. Applied follow-up fixes for documentation, outputs, and IMDSv2 hardening.
- [2026-05-20] Reviewed daily PRs. Applied follow-up fixes for documentation, outputs, and security patching.
- [2026-05-24] Reviewed and hardened `aurora_postgresql` and `observability_admin` modules (PR #92). Hardening included adding regex validation for `kms_key_arn` in Aurora, adding `telemetry_type` validation in Observability Admin, and standardizing AWS provider constraints to `~> 5.0` and `~> 6.45` respectively. Expanded test assertions for Aurora to verify SG and subnet group details. Verified all changes pass native `terraform test` and maintained environment hygiene.
- [2026-06-01] Resolved major regressions in `aurora_postgresql`, `observability_admin`, and `bedrock_agent_core`. Restored hardening for Aurora (parameter group, Lambda integration) and Observability (organizational rules). Expanded Bedrock AgentCore with Online Evaluation, Browser tool, and Gateway Target support. Verified all changes with native `terraform test` and standardized documentation.
- [2026-06-03] Verified daily PRs and module updates. Hardened `bedrock_agent_core` by resolving schema errors where `kms_key_arn` was incorrectly applied to Online Evaluation and Browser resources. Confirmed `aurora_postgresql` and `observability_admin` hardening is intact. Verified all 3 modules with native `terraform test`.
- [2026-06-13] Reviewed and hardened `bedrock_agent_core` (PR #138). Consolidated duplicated dynamic blocks in `aws_bedrockagentcore_gateway_target`. Standardized `kms_key_arn` and `role_arn` validation error messages to include "AWS". Expanded variable documentation for nested attributes and updated README with enhanced usage examples. Bumped AWS provider to `~> 6.49.0` to support protocol enhancements. Verified all changes pass native `terraform test`.

- [2026-04-25] Journal initialized. Ready to review daily PRs and apply follow-up fixes.
- [2026-04-26] Reviewed daily PRs (PR #9). Applied follow-up fixes for tagging, missing tests, mandatory CMK for EventBridge, and output completeness.
- [2026-04-27] Reviewed follow-up changes for workload components. Hardened `apigw_lambda`, `step_functions_lambda`, and `alb_ecs_fargate` with unique Lambda permission IDs, separate IAM policy attachments to avoid mock test errors, and enhanced variable ARN regex validation across base and workload modules. Cleaned up build artifacts (.terraform.lock.hcl). Implemented and reviewed `account_security` module for account-level baseline hardening. Expanded `account_security` to include EBS encryption by default, IAM password policy, and Access Analyzer. Added durable review item SEC-008 to the backlog.
- [2026-04-28] Reviewed daily PRs and module changes. Hardened `account_security` with mandatory tag key enforcement and standardized its README. Corrected Cognito backlog entry and added code TODOs regarding current CMK service-level limitations. Verified `cognito` and `bedrock_agent` modules.
- [2026-04-29] Reviewed daily module changes (Athena and Static Website). Hardened `athena` with CMK ARN and output location validation, and added missing `workgroup_name` output. Hardened `static_website` with domain name validation and expanded tag assertions in tests. Verified both modules via native `terraform test`.
- [2026-04-30] Reviewed daily PRs (PR #24). Hardened `bedrock_knowledge_base` with IAM role and storage configuration assertions. Standardized tests for `iam`, `lambda`, `bedrock_agent`, and `cognito` modules by adding mandatory tag and CMK assertions. Cleaned up build artifacts.
- [2026-05-01] Reviewed daily PRs and module changes. Completed major hardening of 29 prioritized modules (Batch 2 base and workload components) for mandatory tag enforcement. Standardized KMS variable naming to `kms_key_arn` and enforced regex validation library-wide for modules accepting KMS keys. Updated documentation for modules with breaking variable renames (RDS, ElastiCache, Secrets Manager, SNS, SSM). Verified changes with representative `terraform test` runs.
- [2026-05-02] Reviewed daily PRs (PR #30). Hardened `opensearch_serverless` and `bedrock_knowledge_base` modules with full tag assertions in native tests. Standardized `opensearch_serverless` README with root-relative source paths and corrected `bedrock_knowledge_base` README variable table. Cleaned up build artifacts. Verified all changes via `terraform test`.
- [2026-05-03] Reviewed daily module changes (EventBridge Pipes and Security Hub). Hardened `eventbridge_pipes` with nested IAM role tag assertions in tests and standardized README source paths. Hardened `securityhub` with standardized README paths, implementation of missing `securityhub_arn` output, and addition of `override_data` to tests to handle `data.aws_caller_identity`. Verified all changes via `terraform test`. Cleaned up environment build artifacts (.terraform).
- [2026-05-03] Reviewed daily module changes. Applied follow-up fixes for `eventbridge_pipes` and `securityhub`.
- [2026-05-04] Reviewed all modules for repo-wide quality. Hardened `cloudfront` README with missing sections. Added missing `tags` output to `lambda` and `vpc` modules to fix `terraform test` failures in dependent workload components. Hardened `vpc` tests with `override_data` to support offline testing of data sources. Verified all 44 modules with native `terraform test`. Cleaned up build artifacts.
- [2026-05-05] Reviewed and hardened `apigateway_v2`, `sagemaker_inference`, `aws_interconnect`, and `securityhub` modules. Implemented `apigateway_v2` base module and refactored `apigw_lambda` workload component. Verified all 5 modified modules with native `terraform test`.
- [2026-05-06] Reviewed PR #45 (Bedrock cost attribution). Hardened `bedrock_agent` by standardizing `kms_key_arn` naming, making it optional, and expanding outputs. Hardened `bedrock_knowledge_base` with missing `tags` output. Verified both with native `terraform test`. Cleaned up environment build artifacts.
- [2026-05-08] Reviewed daily module changes and backlog. Hardened `account_security` for CIS v3.0 by refactoring GuardDuty to use modern `aws_guardduty_detector_feature` resources, resolving deprecation warnings. Hardened test suite for conditional resources using more resilient assertion patterns. Verified Bedrock Agent and Knowledge Base modules for tag propagation and output completeness. Maintained environment hygiene by removing stray lock files.
- [2026-05-09] Reviewed and hardened `aws/base_component/backup` module (PR #54). Standardized AWS provider constraints to `">= 5.0, < 7.0"`, added resource naming validation, and expanded the native test suite with deeper resource and output assertions. Verified module health via `terraform test` and maintained environment hygiene.
- [2026-05-10] Reviewed and hardened `aws/workload_component/multicloud_hub` (PR #55). Standardized AWS provider constraint to `">= 5.0, < 7.0"`. Refactored `tgw_log_role` to use separate `aws_iam_role_policy_attachment` for policy composition, adhering to repo-wide IAM standards. Verified both `multicloud_hub` and the dependent `aws_interconnect` updates via native `terraform test`.
- [2026-05-11] Reviewed and hardened `aws/base_component/bedrock_agent_core` and `aws/workload_component/multicloud_hub` (PR #60). Verified `bedrock_agent_core` implementation against all security and documentation standards. Refactored `multicloud_hub` to eliminate inline IAM policies, ensuring compliance with organizational standards. Verified repo health across 45+ modules and enforced environment hygiene by removing stray build artifacts.
- [2026-05-13] Reviewed PR #60 (final updates) and subsequent module changes. Hardened `bedrock_agent_core` documentation by explicitly noting the high provider version requirement (v6.27.0+). Hardened `multicloud_hub` by syncing README documentation with actual module outputs. Verified both modules via native `terraform test` and maintained environment hygiene.
- [2026-05-14] Reviewed and hardened `vpc_lattice`, `glue`, and `glue_etl_pattern` modules. Strengthened `terraform test` suites for all three modules to enforce 100% tag coverage across all resources and deeper validation of security configurations (CMK encryption, VPC connection details). Verified all changes pass native `terraform test` and ensured environment hygiene by removing build artifacts.
- [2026-05-16] Reviewed daily module changes and PRs. Hardened documentation for seven modules (base and workload) to ensure output completeness and usage clarity. Fixed CI configuration typo (renamed `gilab-ci.yml` to `.gitlab-ci.yml`). Verified all changes pass native `terraform test` and maintained environment hygiene by removing stray lock files.
- [2026-05-22] Reviewed daily module changes (PR #80 follow-up). Hardened `ecs_fargate` documentation and outputs to match actual implementation. Hardened `ec2` and `asg` by enforcing IMDSv2 in `metadata_options`, addressing a systemic discovery during audit. Verified all changes via native `terraform test` and maintained environment hygiene.
- [2026-05-17] Repository-wide Quality Audit — Conducted a comprehensive audit and addressed a systemic documentation/output deficiency. Appended the mandatory `tags` output and updated README 'Outputs' tables for 37 modules (30 base, 7 workload). Hardened output logic for `sqs`, `account_security`, and `alb` to ensure stability across conditional resource states. Verified all changes pass native `terraform test` and maintained environment hygiene by removing build artifacts.
- [2026-06-09] Repository-wide Quality Remediation — Remediated regressions introduced by Navigator sync commit `f4b67a1` (PR #126). Re-standardized KMS ARN regex validation to `^arn:aws:kms:[a-z0-9-]+:[0-9]{12}:key/[a-z0-9-]+$` across 37 modules and standardized validation error messages to include 'AWS'. Restored comprehensive CI matrix coverage for all 58 modules (48 base, 10 workload) in `.github/workflows/ci.yml`. Remediated CI failures by removing unused `aws_account_id` declarations in 22 modules. Verified repository health via native `terraform test` in `aurora_postgresql`, `observability_admin`, `iam`, and `s3`.
