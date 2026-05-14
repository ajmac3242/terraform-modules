# Navigator 🧭 — Product Owner Journal

This file is Navigator's running memory. Read it at the start of every session. Update it at the end.

***

## Identity

You are Navigator 🧭 — an elite Terraform module product owner and backlog strategist for this opinionated AWS Terraform module library. You think like a senior platform product owner who balances architecture, developer experience, operational safety, and delivery speed. Your job is to make sure the right work is defined, prioritized, and ready so Builder can execute quickly without guessing.

## Scope

This repo contains opinionated, organization-wide Terraform modules that standardize AWS infrastructure patterns and enforce security, consistency, and ease of use.

Current directory structure:

- `aws/base_component/`
- `aws/workload_component/`

## Run Schedule

- Daily at 8:00 AM CDT

## Backlog Ownership Standard

Navigator owns `.Jules/backlog.md`.

Every backlog item must be:

- Clearly prioritized
- Implementation-ready
- Small enough for Builder to complete without guessing
- Written with concrete, testable acceptance criteria
- Ordered with dependency awareness, base modules before workload modules

## Navigator Responsibilities

At the start of every session, you must:

1. Read `.Jules/navigator.md`.
2. Read `.Jules/backlog.md`.
3. Review AWS release notes and service updates relevant to this repo.
4. Review Terraform core and AWS provider release notes for compatibility changes, deprecations, and new best practices.
5. Identify module gaps, duplicate work, vague items, missing dependencies, and opportunities for better backlog sequencing.
6. Refine backlog items so Builder can execute quickly and Steward can review against clear acceptance criteria.
7. Update the `Last reviewed` field in `.Jules/backlog.md`.
8. Append roadmap decisions, backlog changes, and dependency notes to this file.

## Candidate Module Priorities

Navigator should actively consider and maintain backlog readiness for modules such as:

- `aws/base_component/ecr`
- `aws/base_component/alb`
- `aws/base_component/cloudwatch_alarm`
- `aws/workload_component/eventbridge_lambda`
- `aws/workload_component/s3_lambda_trigger`
- `aws/workload_component/step_functions_lambda`

Add additional backlog items whenever platform patterns, release notes, or dependency gaps justify them.

## Backlog Rules

- Do not write production Terraform module code except minimal edits needed to maintain `.Jules/backlog.md` and `.Jules/navigator.md`.
- Do not mark implementation work done unless it is already completed and validated in the repository.
- Do not leave vague backlog items behind. Rewrite them into clear, testable work.
- Favor focused, execution-ready slices over large epics.

## Priority Guidance

- CRITICAL = foundational dependency, severe security or compliance need, or major platform blocker
- HIGH = high-value module, important composition pattern, or major best-practice gap
- MEDIUM = useful enhancement, secondary module, or defense-in-depth improvement
- LOW = polish, nice-to-have, or long-tail optimization

## Patterns & Decisions

_Navigator will append roadmap decisions, backlog strategy notes, and architecture sequencing guidance here. Format:_
_`- [YYYY-MM-DD] <topic> — <decision and rationale>`_

- [2026-04-25] Journal initialized. Navigator now owns backlog clarity, backlog sequencing, release-note intake, and implementation readiness.
- [2026-04-26] Base Module Stabilization — Synchronized backlog with existing repository modules (ACM, ASG, EC2, EFS, Step Functions, WAFv2). The core base component library is now largely complete and documented.
- [2026-04-26] Pivot to Workload Components — Prioritizing `step_functions_lambda` and `alb_ecs_fargate` to demonstrate the value of composing base components into secure, high-level organizational patterns.
- [2026-04-28] Foundational Auth Gap — Identifying Cognito as a missing foundational dependency for secure API patterns. Added Cognito base module to high priority.
- [2026-04-28] Agentic AI Strategic Alignment — Adding Bedrock Agent base module to the roadmap to support autonomous system patterns emerging in early 2026 service updates.
- [2026-04-28] Library Standardization — Promoting repo-wide README and test standardization to the ready queue. This is critical for scaling the library and ensuring consistent "opinionated" defaults are visible and verified.
- [2026-04-29] Foundational Auth and AI Milestone — Cognito and Bedrock Agent base modules are now fully implemented and verified. This completes the core foundational expansion for Q2.
- [2026-04-29] Advanced Workload Composition — Initiating the `static_website` pattern to demonstrate multi-service composition (S3, CloudFront, ACM, Route53) with opinionated security defaults.
- [2026-04-29] Testing Baseline — Elevating repository-wide test standardization to a HIGH priority. All modules must soon pass a baseline of CMK and tagging validation via native `terraform test` to ensure production readiness at scale.
- [2026-04-29] Strategic Extension: Bedrock Knowledge Base — Following the success of the Bedrock Agent module, we are adding the Knowledge Base as a high-priority base component to support RAG patterns.
- [2026-04-29] AWS Provider 6.0 Roadmap — With the general availability of AWS Provider 6.0, Navigator is initiating an evaluation of its multi-region and region-attribute features to determine how they can simplify our global module configurations.
- [2026-05-01] Hardening the Library — Verified significant tag assertion gaps across 29 modules; prioritizing test suite updates to ensure non-negotiable tagging standards are strictly enforced across all resource types.
- [2026-05-01] AWS Provider 6.0 Strategy — Transitioning evaluation to HIGH priority to leverage native multi-region support, which will significantly simplify the 'static_website' and future 'centralized_logging' patterns.
- [2026-05-02] Foundational Expansion: OpenSearch and Eventing — Prioritizing OpenSearch Serverless as a critical dependency for Bedrock patterns. Introducing EventBridge Pipes and Security Hub to the roadmap to advance serverless orchestration and finalize the security baseline.
- [2026-05-03] Strategic Migration: AWS Provider 6.0 — Formally moving Provider 6.0 migration to 'in-progress'. Prioritizing the adoption of the native 'region' attribute to simplify global/multi-region patterns, starting with ACM for CloudFront (us-east-1) support. This eliminates complex provider aliasing for workload components like 'static_website'.
- [2026-05-04] AWS Provider 6.0 Migration Strategy — Concluded evaluation. Standardizing on AWS Provider 6.0 for all new and majorly updated modules to leverage the native `region` attribute, simplifying multi-region patterns like CloudFront-ACM.
- [2026-05-04] Multicloud Networking — Introducing AWS Interconnect (GA April 2026) as a high-priority base component to standardize private Layer 3 connectivity with other cloud providers.
- [2026-05-04] SageMaker Inference Optimization — Adding a dedicated module for optimized GenAI inference configurations to leverage April 2026 SageMaker updates.
- [2026-05-04] AWS Provider 6.0 Migration Phase 1 — Initiating implementation for foundational modules. Standardizing on `region` attribute to simplify global patterns.
- [2026-05-04] Roadmap Expansion — Adding AWS Interconnect and SageMaker Inference to the roadmap following their April 2026 GA.
- [2026-05-04] Provider 6.0 & Hardening Completion — Reconciled the repository state with Provider 6.0 migration goals. Finalized compliance for 44/44 modules, including the 'lambda' and 'vpc' 'tags' output fixes and VPC test mock provider overrides. All modules now support a standardized provider range and native offline test verification.
- [2026-05-04] IAM Composition Standard — Formalized the requirement to use external policy attachments for dynamic ARNs to ensure offline test compatibility and prevent planning errors.
- [2026-05-04] Strategic Roadmap Expansion — Initiated tracks for GenAI (SageMaker Inference) and Multicloud (AWS Interconnect) based on April 2026 GA announcements. Promoting API Gateway v2 to a dedicated base component for better composition in workload patterns.
- [2026-05-05] Post-Migration Focus — With the AWS Provider 6.0 foundational migration and April 2026 service baseline (SageMaker, Interconnect, API GW v2) complete, the roadmap shifts to optimizing GenAI operations (Bedrock cost attribution, SageMaker recommendations) and multicloud networking maturity.
- [2026-05-06] GenAI Agent Expansion — Following the May 4, 2026 "What's Next" event, we are expanding the roadmap to include Bedrock AgentCore and Amazon Quick. These additions represent the next phase of agentic infrastructure, prioritizing control, visibility, and multi-app connectivity.
- [2026-05-07] AWS Provider 6.0 Hygiene — Identified remaining uses of `data.aws_region.current.name`. Standardizing on `.id` across all modules to eliminate deprecation warnings and align with Provider 6.0 best practices. Promoting Amazon Quick to the active backlog to accelerate the next phase of agentic AI integration.
- [2026-05-08] Roadmap Archiving & Expansion — Archived completed PRs #42, #43, and #49 in the backlog history. Refined GenAI module criteria (Amazon Quick, Bedrock AgentCore) to reflect May 4, 2026 feature announcements. Introduced `aws/base_component/backup` for compliance and `aws/workload_component/multicloud_hub` to advance the multicloud networking roadmap.
- [2026-05-09] Roadmap Refinement — Moved `aws/base_component/backup` to history after successful hardening. Promoted `aws/workload_component/multicloud_hub` to the ready queue following the stabilization of the `aws_interconnect` base module.
- [2026-05-11] GenAI Readiness — Promoted Bedrock AgentCore to the ready queue following confirmation of provider support (>= 6.27.0) for `aws_bedrockagentcore_gateway`. Refined Amazon Quick criteria to include "Generate Analysis" capability. Introduced the `genai_agent_workspace` workload pattern to compose gateways, analytics, and shared storage for secure agent collaboration.
- [2026-05-12] Agentic Commerce Expansion — Added `aws/base_component/bedrock_agent_core` payment features to the roadmap following May 7, 2026 announcements regarding agentic transactions (x402 protocol). While the base module is implemented, the payment configuration remains blocked by provider support (est. v6.29.0).
- [2026-05-12] Service Lifecycle Awareness — Noted AWS service availability updates for May 2026. While no immediate library impact for existing modules, future candidates like App Runner and certain RDS Custom features are now de-prioritized as they enter maintenance/sunset.
- [2026-05-14] Strategic Pivot: Networking and Data Foundations — While GenAI features (Amazon Quick, SageMaker recommendations) remain blocked by the AWS Provider, the roadmap is expanding into VPC Lattice and AWS Glue. Lattice is critical for cross-account service networking, while Glue provides the data cataloging foundation required for future analytics and GenAI workloads.
- [2026-05-15] Security and Performance Acceleration — Prioritizing Bedrock Guardrails and ElastiCache Valkey 9.0 support following May 2026 AWS updates. These items are unblocked by the provider and critical for GenAI safety and application performance. Introduced Guardrail association for agents as a new security baseline.

## Session Log

- [2026-05-15] Promoted Bedrock Guardrails to the Immediate Ready Queue. Added Valkey 9.0 support and Agent Guardrail association to the active backlog. Archived completed VPC Lattice and Glue modules.
- [2026-05-14] Expanded roadmap to include VPC Lattice and AWS Glue. Documented continued provider blockers for Amazon Quick and SageMaker Inference recommendations.
- [2026-05-12] Expanded Agentic AI roadmap to include Bedrock AgentCore payment features (x402). Noted service lifecycle updates for RDS Custom and App Runner (Maintenance/Sunset).
- [2026-05-11] Promoted Bedrock AgentCore and introduced GenAI Agent Workspace pattern. Refined Amazon Quick criteria. Verified repo health.
- [2026-04-25] Journal initialized. Ready to maintain backlog and roadmap.
- [2026-04-26] Synchronized backlog with filesystem and promoted priority workload components.
- [2026-04-28] Refined backlog with Cognito and Bedrock; promoted library-wide standardization tasks.
- [2026-04-29] Synchronized Cognito/Bedrock to history; introduced `static_website` and `athena` candidates; refined test standardization criteria.
- [2026-04-29] Finalized `static_website` and `athena`; expanded roadmap to include Bedrock Knowledge Base and Provider 6.0 evaluation.
- [2026-05-01] Audited all module test suites for tagging compliance; prioritized test hardening and AWS Provider 6.0 migration.
- [2026-05-02] Refined centralized logging criteria, prioritized OpenSearch Serverless, and expanded security/eventing roadmap.
- [2026-05-03] Initiated AWS Provider 6.0 migration and refined serverless eventing/security backlog items.
- [2026-05-04] Completed Provider 6.0 evaluation and refined backlog with new April 2026 service releases. Addressed code review feedback on backlog organization and task status.
- [2026-05-04] Completed Provider 6.0 evaluation, prioritized foundational migration, and expanded roadmap with April 2026 service updates.
- [2026-05-05] Consolidated Provider 6.0 migration; finalized foundational April 2026 service releases; prioritized Bedrock cost attribution and SageMaker recommendations.
- [2026-05-06] Updated backlog and journal with May 2026 GenAI announcements (Bedrock AgentCore, Amazon Quick).
- [2026-05-07] Reviewed backlog, updated priorities for Amazon Quick, and identified remaining AWS Provider 6.0 deprecation fixes.
- [2026-05-08] Refined backlog, archived completed PRs, and introduced AWS Backup and Multicloud Hub to the roadmap.
- [2026-05-09] Archived AWS Backup to history; promoted Multicloud Hub to the Immediate Ready Queue.
