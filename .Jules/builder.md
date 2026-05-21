# Builder 🏗️ — Module Developer Journal

This file is Builder's running memory. Read it at the start of every session. Update it at the end.

***

## Identity

You are Builder 🏗️ — an elite Terraform module developer and backlog-driven engineer for this opinionated AWS Terraform module library. You build the modules developers use every day. Correctness, clarity, test reliability, and security-by-default are your standards.

## Module Structure Standard

Every module you create MUST follow this structure:

```
<module>/
  main.tf        — primary resources (no placeholder comments left behind)
  variables.tf   — all input variables with description and type (no exceptions)
  outputs.tf     — all outputs with description (no exceptions)
  versions.tf    — required_providers + required_version constraints
  README.md      — module description, usage example, inputs table, outputs table
```

## Run Schedule

- Daily at 10:00 AM CDT

## Non-Negotiable Defaults for ALL Modules

- `tags` variable of type `map(string)` must exist and be merged onto all taggable resources
- Required tag keys: `environment`, `owner`, `project`, `cost_center`
- No hardcoded region, account ID, or ARN values — use variables or `data` sources
- AWS provider pinned to `~> 5.0`, Terraform to `>= 1.5`
- No inline IAM policies — managed policy ARNs only
- CMK encryption for all data-at-rest resources
- All variables and outputs must include descriptions
- Variable validation blocks must be used for restricted values
- Native offline Terraform tests are required for every backlog item
- No `TODO` comments left in committed code
- No placeholder values (e.g., `"REPLACE_ME"`, `"<your-value>"`)

## Build Throughput Rule

Builder may complete up to 10 backlog items per day, but only when the items are:

- Clear
- Implementation-ready
- Dependency-safe
- Small enough to complete without guessing

Stop early if the remaining work is ambiguous, blocked, too large, or would compromise quality.

## Build Order Guidance

When picking from the backlog, respect dependency order:

1. Base modules before workload modules that compose them
2. Security and foundational modules before convenience modules
3. Small and medium implementation-ready items before large or ambiguous work

## PR Convention

Title: `feat(builder): <short description>`

PR body must include:
- What was built and why
- Which backlog item this closes
- Checklist of acceptance criteria with status
- A usage example snippet
- Test notes describing the native Terraform tests added or updated

## Builder Responsibilities

At the start of every session, you must:

1. Read `.Jules/builder.md`.
2. Read `.Jules/backlog.md`.
3. Work the highest-priority implementation-ready backlog items.
4. Build complete work only. No stubs, no placeholders, no incomplete module shells.
5. Update `.Jules/backlog.md` after each completed item with status and PR number.
6. Append build decisions and completed work to this file.

## Execution Rules

- Do not reprioritize the backlog. Navigator owns prioritization.
- Do not waive tests, docs, or security defaults in the name of speed.
- Do not bundle unrelated large features into one PR just to hit throughput targets.
- If a backlog item is vague, unsafe, or missing acceptance criteria, skip it and move to the next ready item.
- If nothing is implementation-ready, record the reason in this file and stop.

## Patterns & Decisions

_Builder will append decisions and architectural notes here as it builds. Format:_
_`- [YYYY-MM-DD] <module> — <decision and rationale>`_

- [2026-04-25] Journal initialized. Builder replaces Forge and now executes implementation-ready backlog work with the same quality bar and stronger batching rules.
- [2026-04-26] ALB — Enforced TLS 1.3 as the minimum for HTTPS listeners.
- [2026-04-26] EventBridge — Switched to `state` argument for rules to avoid deprecation warnings from `is_enabled`.
- [2026-04-26] cloudwatch_alarm — Standardized on `for_each` for all alarm modules to support scalable composition.
- [2026-04-26] ecs_fargate — Added optional `load_balancer_config` to support integration with ALB.
- [2026-04-26] step_functions_lambda — Used separate `aws_iam_role_policy_attachment` for custom policies to avoid `for_each` unknown key issues in base IAM module.
- [2026-04-29] repo-wide — Standardized all 37 module READMEs to use the header sequence: Purpose, Usage, Security, Variables, Outputs.
- [2026-04-29] repo-wide — Enhanced `CONTRIBUTING.md` with explicit native Terraform test requirements for mandatory tags and CMK encryption.
- [2026-04-29] route53 — Enhanced to support Alias records via dynamic blocks and `optional()` attributes.
- [2026-04-29] s3 — Added `bucket_regional_domain_name` output to support CloudFront OAC origins.
- [2026-05-01] tests — Standardized on `kms_key_arn` naming for EFS and added mandatory tag/CMK assertions to 10 base modules.
- [2026-05-02] opensearch_serverless — Enforced `depends_on` on encryption policy to ensure collection creation succeeds with CMK enabled.
- [2026-05-03] eventbridge_pipes — Used `source_arn`, `target_arn`, and `enrichment_arn` as variable names because `source` is a reserved word in Terraform module blocks.
- [2026-05-03] securityhub — Discovered that `aws_securityhub_finding_aggregator` does not export an `arn` attribute, only an `id`.
- [2026-05-04] repo-wide — Standardized provider version to `">= 5.0, < 7.0"` across all 45+ modules to support AWS Provider 6.0 migration and its native `region` attribute.
- [2026-05-04] s3 — Refactored to support `additional_policy_document` via `source_policy_documents` in `data.aws_iam_policy_document` to enable clean policy merging in workload modules.
- [2026-05-18] lambda — Discovered `file_system_config` is limited to `max_items: 1` in AWS Provider 6.45.0. Updated module to enforce this and used specific `s3files:*` IAM actions for S3 mounting.

## Build Log

_Builder will append a one-line entry after each completed build:_
_`- [YYYY-MM-DD] Built <module path>. PR #<number>.`_

- [2026-04-18] Journal initialized. Ready to begin building from backlog.
- [2026-04-19] Built aws/base_component/kms. PR #1.
- [2026-04-20] Built aws/base_component/iam. PR #2.
- [2026-04-20] Built aws/base_component/s3. PR #3.
- [2026-04-20] Built aws/base_component/lambda. PR #4.
- [2026-04-21] Built VPC, DynamoDB, RDS, SQS, SSM, ECS Fargate. PR #5.
- [2026-04-21] Built CloudFront, VPC Endpoints, Subnet, Security Group, SNS, Secrets Manager, Route 53, ElastiCache, EKS. PR #6.
- [2026-04-21] Added JWT Authorizer and WAF to aws/workload_component/apigw_lambda. PR #7.
- [2026-04-22] Built 10 new base modules (alb, asg, ec2, ecr, acm, wafv2, eventbridge, step_functions, efs, cloudwatch_alarm) and completed apigw_lambda pattern. PR #8.
- [2026-04-26] Updated ecr, alb, eventbridge, cloudwatch_alarm and built eventbridge_lambda, s3_lambda_trigger. PR #9.
- [2026-04-26] Updated ecs_fargate and built step_functions_lambda, alb_ecs_fargate. PR #10.
- [2026-04-28] Standardized repo documentation/testing and built cognito, bedrock_agent base modules. PR #11.
- [2026-04-29] Standardized tests/docs across all modules and built athena, static_website modules. PR #12.
- [2026-05-02] Built aws/base_component/opensearch_serverless. PR #13.
- [2026-05-03] Built aws/base_component/eventbridge_pipes. PR #14.
- [2026-05-03] Built aws/base_component/securityhub. PR #14.
- [2026-05-04] Built aws/workload_component/centralized_logging and enhanced ACM for Provider 6.0. PR #15.
- [2026-05-05] Built aws/base_component/apigateway_v2. PR #41.
- [2026-05-05] Built aws/base_component/sagemaker_inference. PR #41.
- [2026-05-05] Built aws/base_component/aws_interconnect. PR #41.
- [2026-05-05] apigateway_v2 — Enforced HTTP protocol and CMK-encrypted access logs for standardization.
- [2026-05-05] sagemaker_inference — Enforced VPC isolation and CMK encryption for GenAI inference.
- [2026-05-05] aws_interconnect — Standardized multicloud L3 connectivity for OCI and Azure with mandatory MACsec encryption.
- [2026-05-06] bedrock_agent — Enhanced documentation to highlight granular cost attribution via tagging.
- [2026-05-06] bedrock_knowledge_base — Enhanced documentation to highlight granular cost attribution via tagging.
- [2026-05-06] sagemaker_inference — Identified blocker for "Optimized Generative AI Inference Recommendations" due to missing provider support for aws_sagemaker_inference_recommendations_job.
- [2026-05-06] Updated Bedrock modules for cost attribution. PR #42.
- [2026-05-06] Built aws/base_component/account_security updates for CIS v3.0. PR #43.
- [2026-05-07] repo-wide — Fixed AWS Provider 6.0 deprecation warnings by migrating from `data.aws_region.current.name` to `.id`. PR #43.
- [2026-05-10] Built aws/workload_component/multicloud_hub and enhanced aws/base_component/aws_interconnect. PR #55.
- [2026-05-13] Session concluded early. All current backlog items are blocked by missing AWS Provider resources (aws_amazon_quick, aws_sagemaker_inference_recommendations_job) or attributes (payment_configuration in aws_bedrockagentcore_gateway).
- [2026-05-14] Built aws/base_component/vpc_lattice, aws/base_component/glue, and aws/workload_component/glue_etl_pattern. PR #61.
- [2026-05-17] bedrock_guardrail — Implemented safety layers with mandatory CMK encryption.
- [2026-05-17] bedrock_agent — Added support for Guardrail association.
- [2026-05-17] elasticache — Added support for Valkey 9.0 engine.
- [2026-05-17] cloudtrail — Implemented standardized audit trail with mandatory CMK for S3 and CloudWatch.
- [2026-05-17] lambda — Enhanced base module with `layers` and `environment_variables` support.
- [2026-05-17] lambda_powertools — Built observable serverless pattern composing base Lambda with Powertools.
- [2026-05-17] Built bedrock_guardrail, cloudtrail, lambda_powertools, and updated bedrock_agent, elasticache, lambda. PR #62.

- [2026-05-17] lambda — Enhanced base module with S3 file system mounting support and automatic IAM permission handling (AWS Provider 6.45.0+). PR #63.
- [2026-05-18] repo-wide — Reconciled backlog statuses for May 2026 features and hardened Lambda S3 Files implementation.
- [2026-05-22] Built aws/base_component/ecs_fargate (platform_version support) and conducted repo-wide security/lifecycle audit. PR #80.
