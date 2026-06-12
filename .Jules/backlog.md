# Terraform Modules — Product Backlog

> **Maintained by:** Navigator (daily backlog ownership), Builder (marks implemented items done), Steward (adds review-discovered follow-up work)
> **Last reviewed:** 2026-06-12
> **Purpose:** Single source of truth for module roadmap, implementation-ready backlog items, acceptance criteria, review-discovered gaps, and strategic module expansion for this opinionated AWS Terraform module library.

***

## How This File Works

- **Navigator** (Jules, runs daily at 8:00 AM CDT) owns this file. Navigator reviews AWS and Terraform release notes, identifies module gaps, refines acceptance criteria, de-duplicates work, and ensures the highest-priority backlog items are implementation-ready.
- **Builder** (Jules, runs daily at 10:00 AM CDT) reads this file, works the highest-priority implementation-ready `backlog` items, opens PRs, and marks completed items `done` with PR numbers.
- **Steward** (Jules, runs daily at 4:00 PM CDT) reviews the day's PRs, fixes clear low-risk issues, and adds new follow-up backlog items when review uncovers durable gaps or recurring quality issues.

### Backlog Item Format

```
### <module-path>: <short title>

**Priority:** CRITICAL | HIGH | MEDIUM | LOW
**Type:** Security | Feature | Maintenance | Refactor | Documentation | Testing
**Status:** `backlog` | `in-progress` | `done`
**Module:** aws/base_component/<name> or aws/workload_component/<name>
**Why:** <rationale>

#### Acceptance Criteria
- [ ] <criterion>
- [ ] <criterion>

#### Security Notes (if applicable)
- <note>
```

***

## Global Standards & Conventions

All modules in this repo MUST comply with these non-negotiable standards:

- **Tagging** — Accept and enforce a `tags` variable (map of strings). Required keys: `environment`, `owner`, `project`, `cost_center`.
- **No inline IAM policies** — IAM inline policies are forbidden. Use managed policy ARNs only.
- **CMK encryption** — All data-at-rest resources (S3, DynamoDB, RDS, EBS, ECR, Secrets Manager, SSM Parameter Store, CloudWatch Logs where supported) must use a customer-managed KMS key (CMK). The module must create or accept the key ARN when the service supports CMK encryption.
- **Least privilege** — IAM roles scoped to minimum required permissions. No `*` actions or resources unless explicitly justified in a comment.
- **VPC-first** — Compute resources (Lambda, RDS, ECS, EKS, EC2) must support VPC placement with configurable subnet IDs and security group IDs where applicable.
- **Versioned providers** — Each module must pin `required_providers` with a `~>` constraint and set a `required_version` for Terraform.
- **Outputs** — Every module must output at minimum: the primary resource ARN, resource ID/name, and any generated role/key ARNs.
- **Variable validation** — Use Terraform `validation` blocks for any variable with restricted allowed values.
- **Described everything** — All variables and outputs must have `description` fields. No exceptions.
- **Tests are mandatory** — Native offline `terraform test` coverage is required for every module change and must validate the item's acceptance criteria.
- **Documentation is mandatory** — Every module requires a README with purpose, usage example, inputs, outputs, notable defaults, and security-relevant behavior.
- **IAM Composition Standard** — When attaching resource-derived policy ARNs (e.g., from an `aws_iam_policy` created in the same plan) to a role created via the base IAM module, use a separate `aws_iam_role_policy_attachment` in the calling module instead of passing it to the `managed_policy_arns` variable. This avoids `for_each` planning errors caused by unknown keys in mock environments.

***

## Immediate Ready Queue

### aws/base_component/cognito: Support Multi-Region Replication

**Priority:** HIGH
**Type:** Feature
**Status:** `backlog`
**Module:** aws/base_component/cognito
**Why:** Cognito now supports multi-Region replication (announced June 8, 2026), enabling synchronization of user and machine identity data for global resilience and low-latency access.

> [!IMPORTANT]
> **Blocker:** Pending AWS Provider support for `replica_regions` (or equivalent) in `aws_cognito_user_pool`. Verified still blocked in AWS Provider v6.50.0 audit. (Verified by Navigator 2026-06-12)

#### Acceptance Criteria
- [ ] Implement `aws_cognito_user_pool` replication to secondary Regions
- [ ] Mandatory requirement: Configure a multi-Region customer managed key (CMK) for data-at-rest encryption before enabling replication
- [ ] Support for configuring the OIDC issuer type (multi-region endpoints)
- [ ] Support for manual activation of the replicated user pool
- [ ] Support for synchronizing user pools, credentials, and federation setups
- [ ] Integration with Route 53 health check IDs for automated failover
- [ ] Support for near real-time data synchronization
- [ ] Required `tags` enforced
- [ ] Native offline Terraform test validates replication and encryption configuration

---

### aws/base_component/bedrock_agent_runtime: Support Interactive Shells

**Priority:** HIGH
**Type:** Feature
**Status:** `backlog`
**Module:** aws/base_component/bedrock_agent_runtime
**Why:** Bedrock AgentRuntime now supports interactive shells (announced June 5, 2026), enabling developers to access persistent, terminal-based sessions for agentic execution.

#### Acceptance Criteria
- [ ] Support for `InvokeAgentRuntimeCommandShell` API via provider resources/data sources
- [ ] Support for persistent PTY-based sessions
- [ ] Mandatory CMK encryption for shell session logs and state
- [ ] Required `tags` enforced
- [ ] Native offline Terraform test validates shell configuration

---

### aws/base_component/resiliencehub: Opinionated AWS Resilience Hub (Next Generation) module

**Priority:** HIGH
**Type:** Feature
**Status:** `backlog`
**Module:** aws/base_component/resiliencehub
**Why:** Next Generation Resilience Hub (GA June 1, 2026) provides a unified framework for resilience standards, modular policies (SLOs, DR, data recovery), and generative AI-powered assessments. Standardizing these policies is critical for organizational SRE and compliance posture.

#### Acceptance Criteria
- [ ] `aws_resiliencehub_resiliency_policy` implementation for standardized RTO/RPO targets
- [ ] Support for modular resilience policies covering service-level objectives (SLOs)
- [ ] Support for multi-AZ/Region DR and data recovery policies
- [ ] Implementation of business-oriented application modeling (AppRegistry integration)
- [ ] Support for Generative AI-powered resilience assessments
- [ ] Mandatory CMK encryption for any underlying assessment reports or state
- [ ] Required `tags` enforced
- [ ] Native offline Terraform test validates policy configuration and application mapping

---

### aws/base_component/aurora_mysql: Opinionated Aurora MySQL module with Kiro Powers integration

**Priority:** HIGH
**Type:** Feature
**Status:** `backlog`
**Module:** aws/base_component/aurora_mysql
**Why:** Support for Kiro Powers (MCP) integration (announced May 2026) to enable AI-assisted database operations and schema management. Bundles best practices for Aurora MySQL Serverless v2, automated scaling, and secure IAM integration for AI-DLC workflows.

#### Acceptance Criteria
- [ ] `aws_rds_cluster` with `engine = "aurora-mysql"` and `engine_version` >= 8.0.mysql_aurora.3.x
- [ ] Support for Aurora Serverless v2 (`serverlessv2_scaling_configuration`)
- [ ] Configure `aws_rds_cluster_parameter_group` with opinionated performance and security defaults
- [ ] Implementation of IAM roles and associations for Kiro MCP integration (Control plane and Data plane)
- [ ] Mandatory CMK encryption for storage and CloudWatch logs
- [ ] Placed in VPC private subnets with dedicated `aws_db_subnet_group`
- [ ] Point-in-time recovery (PITR) enabled (7 days minimum)
- [ ] Storage type `aurora-iopt1` (I/O-Optimized) enabled by default
- [ ] Required `tags` enforced
- [ ] Native offline Terraform test validates encryption, scaling configuration, and IAM associations

---

### aws/base_component/bedrock_agent_core: Support Gateway MCP Enhancements

**Priority:** HIGH
**Type:** Feature
**Status:** `backlog`
**Module:** aws/base_component/bedrock_agent_core
**Why:** Expanding the Bedrock AgentCore module to support advanced MCP gateway controls for streaming and session management. Confirmed in AWS Provider v6.49.0.

#### Acceptance Criteria
- [ ] Implement `protocol_configuration.mcp.session_configuration` for fine-grained session control
- [ ] Implement `protocol_configuration.mcp.streaming_configuration` for real-time streaming tool support
- [ ] Mandatory CMK encryption for session state and logs
- [ ] Required `tags` enforced
- [ ] Native offline Terraform test validates gateway enhancements

---

### aws/base_component/bedrock_agent_core: Support Enhanced Gateway Target Configuration

**Priority:** HIGH
**Type:** Feature
**Status:** `backlog`
**Module:** aws/base_component/bedrock_agent_core
**Why:** AWS Provider v6.48.0 added support for `credential_provider_configuration.jwt_passthrough`, `credential_provider_configuration.caller_iam_credentials`, SigV4 signing for MCP servers, and direct HTTP targets.

#### Acceptance Criteria
- [ ] Support `credential_provider_configuration.jwt_passthrough` and `caller_iam_credentials`
- [ ] Support SigV4 signing for mcp_server targets via `gateway_iam_role.service` and `region`
- [ ] Support `target_configuration.http` for routing to non-MCP HTTP targets
- [ ] Required `tags` enforced (where supported)
- [ ] Native offline Terraform test validates target enhancements

---

### aws/base_component/observability_admin: Support Expanded Rule Schema

**Priority:** MEDIUM
**Type:** Feature
**Status:** `backlog`
**Module:** aws/base_component/observability_admin
**Why:** AWS Provider v6.48.0 expanded the telemetry rule schema to support destination configurations for CloudTrail, ELB, Log Delivery, MSK, VPC Flow Logs, and WAF.

#### Acceptance Criteria
- [ ] Implement `destination_configuration` block with all sub-parameters
- [ ] Support for `selection_criteria`, `telemetry_source_types`, and `scope`
- [ ] Update organizational rule support to match the expanded schema
- [ ] Mandatory CMK encryption for any underlying log destinations
- [ ] Required `tags` enforced
- [ ] Native offline Terraform test validates expanded rule configuration

---

### aws/base_component/opensearch_serverless: Support Generation attribute

**Priority:** MEDIUM
**Type:** Feature
**Status:** `done` (PR #134)
**Module:** aws/base_component/opensearch_serverless
**Why:** AWS Provider v6.49.0 added the `generation` attribute to `aws_opensearchserverless_collection_group`, enabling better tracking of collection group iterations.

#### Acceptance Criteria
- [x] Support `generation` attribute in `aws_opensearchserverless_collection_group`
- [x] Update data source to expose `generation`
- [x] Required `tags` enforced
- [x] Native offline Terraform test validates attribute propagation

---

### aws/base_component/bedrock_agent_runtime: Opinionated Bedrock Agent Runtime module

**Priority:** HIGH
**Type:** Feature
**Status:** `backlog`
**Module:** aws/base_component/bedrock_agent_runtime
**Why:** Following the GA of Bedrock Agentic AI features (May 2026), a dedicated runtime module is needed to manage agent invocation, session state, filesystem mounting (S3/EFS) for agentic execution, and low-latency runtime endpoints. Confirmed unblocked in AWS Provider v6.48.0.

#### Acceptance Criteria
- [ ] `aws_bedrockagentcore_agent_runtime` and `aws_bedrockagentcore_agent_runtime_endpoint` implementation
- [ ] Support for `protocol_configuration` and `server_protocol`
- [ ] Support for `authorizer_configuration` (Custom JWT Authorizer)
- [ ] Support for `network_configuration` with `network_mode_config` (VPC sandboxing)
- [ ] Support for `filesystem_configuration` (EFS, S3 Files, and Session Storage)
- [ ] Support for `request_header_configuration` (allowlists)
- [ ] Support for `environment_variables` and `lifecycle_configuration`
- [ ] Support for Interactive Shells via `InvokeAgentRuntimeCommandShell`
- [ ] Standardized runtime endpoint configuration for low-latency agentic interactions
- [ ] Mandatory CMK encryption for mounted session storage and persistent session state
- [ ] Least-privilege IAM roles for agent invocation and filesystem access
- [ ] Required `tags` enforced
- [ ] Native offline Terraform test validates runtime, filesystem, and authorizer configuration

---

### aws/base_component/bedrock_agent_memory: Opinionated Bedrock Agent Memory module

**Priority:** HIGH
**Type:** Feature
**Status:** `backlog`
**Module:** aws/base_component/bedrock_agent_memory
**Why:** Bedrock Agent Memory (confirmed in AWS Provider v6.48.0) provides persistent, long-term session storage for agents, enabling them to retain context across multiple interactions and sessions.

#### Acceptance Criteria
- [ ] `aws_bedrockagentcore_memory` and `aws_bedrockagentcore_memory_strategy` implementation
- [ ] Support for session-pinned and persistent memory strategies
- [ ] Mandatory CMK encryption for all stored memory data (`encryption_key_arn`)
- [ ] Support for data retention and archival policies (`event_expiry_duration`)
- [ ] Required `tags` enforced
- [ ] Native offline Terraform test validates memory configuration and security

---

### aws/base_component/bedrock_agent_policy_engine: Opinionated Bedrock Agent Policy Engine module

**Priority:** HIGH
**Type:** Feature
**Status:** `backlog`
**Module:** aws/base_component/bedrock_agent_policy_engine
**Why:** Bedrock Agent Policy Engine (confirmed in AWS Provider v6.48.0) enables fine-grained, policy-based authorization for agent actions, improving security and governance for autonomous workloads.

#### Acceptance Criteria
- [ ] `aws_bedrockagentcore_policy_engine` and `aws_bedrockagentcore_resource_policy` implementation
- [ ] Support for defining granular action-level permissions for agents
- [ ] Mandatory CMK encryption for policy definitions (`encryption_key_arn`)
- [ ] Required `tags` enforced
- [ ] Native offline Terraform test validates policy configuration and enforcement

---

### aws/base_component/cloudfront: Support Cache Tagging

**Priority:** MEDIUM
**Type:** Maintenance
**Status:** `done` (PR #134)
**Module:** aws/base_component/cloudfront
**Why:** AWS Provider v6.46.0 introduced `cache_tag_config` to `aws_cloudfront_distribution`, enabling more granular cache invalidation patterns via tags.

#### Acceptance Criteria
- [x] Implement `cache_tag_config` block in `aws_cloudfront_distribution`
- [x] Support for enabling/disabling cache tagging via variables
- [x] Required `tags` enforced
- [x] Native offline Terraform test validates configuration

---

### aws/base_component/bedrock_agent: Support Claude Fable 5 and Mythos safeguards

**Priority:** HIGH
**Type:** Feature
**Status:** `backlog`
**Module:** aws/base_component/bedrock_agent
**Why:** Support for Claude Fable 5 (announced June 9, 2026) brings "Mythos-class" capabilities and safety safeguards to agents.

#### Acceptance Criteria
- [ ] Support for `anthropic.claude-fable-5-v1:0` model ID
- [ ] Support for Mythos-class safeguards and reasoning parameters (including `reasoning_depth` and `logic_consistency` checks)
- [ ] Support for autonomous planning, self-verification, and autonomous refinement for long-running tasks (days-long execution)
- [ ] Update documentation to reflect model availability and safety features
- [ ] Required `tags` enforced
- [ ] Native offline Terraform test validates agent model configuration

---

### aws/base_component/ecs_fargate: Support Deployment Pause Points

**Priority:** MEDIUM
**Type:** Feature
**Status:** `backlog`
**Module:** aws/base_component/ecs_fargate
**Why:** Amazon ECS now enables pausing service deployments at critical stages (announced June 2026), allowing for manual decision points and interactive verification during progression.

#### Acceptance Criteria
- [ ] Support for `pause_deployment` configurations in `aws_ecs_service`
- [ ] Support for defining multiple pause points based on deployment percentages or specific events
- [ ] Support for manual 'continue' signals via API/CLI
- [ ] Required `tags` enforced
- [ ] Native offline Terraform test validates pause point configuration

---

### aws/base_component/elasticache: Support Valkey Durability

**Priority:** HIGH
**Type:** Feature
**Status:** `backlog`
**Module:** aws/base_component/elasticache
**Why:** ElastiCache for Valkey now supports built-in durability (announced June 2, 2026), addressing persistent memory challenges for AI agent state and long-term memory.

#### Acceptance Criteria
- [ ] Support for `durability_enabled` and `persistence_config` in `aws_elasticache_replication_group`
- [ ] Support for configuring snapshot-based persistence and aof-based durability
- [ ] Mandatory CMK encryption for persisted data at rest
- [ ] Required `tags` enforced
- [ ] Native offline Terraform test validates durability and encryption settings

---

### aws/base_component/bedrock_agent: Support Expanded Session TTL

**Priority:** LOW
**Type:** Maintenance
**Status:** `done` (PR #134)
**Module:** aws/base_component/bedrock_agent
**Why:** AWS Provider v6.46.0 increased the maximum value for `idle_session_ttl_in_seconds` from 3600 to 5400.

#### Acceptance Criteria
- [x] Update `variable "idle_session_ttl_in_seconds"` validation to allow values up to 5400
- [x] Update documentation to reflect the new maximum TTL
- [x] Native offline Terraform test validates the new upper bound

---

### aws/base_component/ecs_fargate: Support 32vCPU configurations

**Priority:** MEDIUM
**Type:** Feature
**Status:** `done` (PR #134)
**Module:** aws/base_component/ecs_fargate
**Why:** Amazon ECS with AWS Fargate now supports 32vCPU compute configurations (announced June 5, 2026), enabling larger workloads.

#### Acceptance Criteria
- [x] Update `cpu` variable validation to allow values up to 32768 (32vCPU)
- [x] Update `memory` variable validation to support corresponding memory limits for 32vCPU
- [x] Update documentation to reflect new compute limits
- [x] Native offline Terraform test validates the new upper bounds

---

### aws/base_component/eks: Support CloudWatch Vended Logs

**Priority:** MEDIUM
**Type:** Feature
**Status:** `backlog`
**Module:** aws/base_component/eks
**Why:** Amazon EKS now supports Amazon CloudWatch Vended Logs (announced June 4, 2026), providing a more cost-effective way to manage cluster logs.

#### Acceptance Criteria
- [ ] Implement support for CloudWatch Vended Logs configuration in `aws_eks_cluster`
- [ ] Support for configuring log types and destinations
- [ ] Mandatory CMK encryption for log groups
- [ ] Required `tags` enforced
- [ ] Native offline Terraform test validates vended logs configuration

***

## Module Backlog

### aws/base_component/xray: Opinionated AWS X-Ray module

**Priority:** MEDIUM
**Type:** Feature
**Status:** `backlog`
**Module:** aws/base_component/xray
**Why:** AWS Provider v6.46.0 introduced `aws_xray_indexing_rule` and `aws_xray_trace_segment_destination`, enabling standardized control over trace indexing and destination management for organizational observability.

#### Acceptance Criteria
- [ ] `aws_xray_indexing_rule` implementation for fine-grained indexing control
- [ ] `aws_xray_trace_segment_destination` implementation for managing trace data delivery
- [ ] Support for `aws_xray_resource_policy` and `aws_xray_sampling_rule` (with Resource Identity)
- [ ] Mandatory CMK encryption for any data at rest
- [ ] Required `tags` enforced
- [ ] Native offline Terraform test validates X-Ray resource configurations

---

### aws/base_component/vpc_lattice: Support DNS Resolution Configuration

**Priority:** LOW
**Type:** Maintenance
**Status:** `backlog`
**Module:** aws/base_component/vpc_lattice
**Why:** AWS Provider v6.46.0 introduced `resource_config_dns_resolution` to `aws_vpclattice_resource_gateway`, enabling better control over how Lattice resolves service DNS.

#### Acceptance Criteria
- [ ] Implement `resource_config_dns_resolution` argument in `aws_vpclattice_resource_gateway`
- [ ] Support for enabling/disabling DNS resolution via variables
- [ ] Required `tags` enforced
- [ ] Native offline Terraform test validates configuration

---

### aws/base_component/bedrock_agent_token_vault: Opinionated Bedrock Agent Token Vault module

**Priority:** HIGH
**Type:** Feature
**Status:** `backlog`
**Module:** aws/base_component/bedrock_agent_token_vault
**Why:** Bedrock Agent Token Vault (confirmed in AWS Provider v6.48.0) manages sensitive credentials (API keys, OAuth2) for agents using a secure, hardware-backed vault.

#### Acceptance Criteria
- [ ] `aws_bedrockagentcore_token_vault_cmk` implementation
- [ ] `aws_bedrockagentcore_api_key_credential_provider` and `aws_bedrockagentcore_oauth2_credential_provider` support
- [ ] Mandatory CMK encryption for vault keys and secrets
- [ ] Integration with Secrets Manager for backend credential storage
- [ ] Required `tags` enforced
- [ ] Native offline Terraform test validates vault and credential provider configuration

---

### aws/base_component/bedrock_agent_harness: Opinionated Bedrock Agent Harness module

**Priority:** MEDIUM
**Type:** Feature
**Status:** `backlog`
**Module:** aws/base_component/bedrock_agent_harness
**Why:** Bedrock Agent Harness (confirmed in AWS Provider v6.48.0) provides a standardized testing environment for agents, enabling automated evaluation and debugging.

#### Acceptance Criteria
- [ ] `aws_bedrockagentcore_harness` implementation
- [ ] Support for defining testing environment, variables, and allowed tools
- [ ] Support for iteration limits and timeouts
- [ ] Mandatory CMK encryption for test logs and state
- [ ] Required `tags` enforced
- [ ] Native offline Terraform test validates harness configuration

---

### aws/base_component/extenddb: Opinionated AWS ExtendDB module

**Priority:** HIGH
**Type:** Feature
**Status:** `backlog`
**Module:** aws/base_component/extenddb
**Why:** AWS ExtendDB (announced May 20, 2026) allows extending existing relational databases with scalable AI-powered capabilities or providing a managed DynamoDB-compatible adapter with pluggable storage.

> [!IMPORTANT]
> **Blocker:** Pending AWS Provider support for `aws_extenddb_cluster` (or equivalent) resource. Verified still blocked in June 2026 provider audit. (Verified by Navigator 2026-06-12)

#### Acceptance Criteria
- [ ] `aws_extenddb_cluster` (or equivalent) resource implementation
- [ ] Support for extending RDS/Aurora clusters or deploying as a standalone adapter (e.g., via container/EC2)
- [ ] Support for archival policies based on age or row-level metadata
- [ ] Mandatory CMK encryption for all data at rest and archived data in S3
- [ ] Placed in VPC private subnets with least-privilege IAM roles
- [ ] Required `tags` enforced
- [ ] Native offline Terraform test validates security and extension configuration

---

### aws/base_component/aws_transform: Opinionated AWS Transform module

**Priority:** MEDIUM
**Type:** Feature
**Status:** `backlog`
**Module:** aws/base_component/aws_transform
**Why:** AWS Transform (GA May 20, 2026) provides managed data transformation, migration, and agentic modernization for code and networks.

> [!IMPORTANT]
> **Blocker:** Pending AWS Provider support for `aws_transform_job` / `aws_transform_project` (or equivalent) resource. Verified still blocked in June 2026 provider audit. (Verified by Navigator 2026-06-12)

#### Acceptance Criteria
- [ ] `aws_transform_job` / `aws_transform_project` / `aws_transform_modernization_job` resource implementation
- [ ] Support for Agentic Readiness Analysis (ARA) and Modernization Analysis (MODA)
- [ ] Support for source and target data store configurations (S3, Kinesis, MSK)
- [ ] Support for transformation logic using SQL, Python, or automated modernization (code/network)
- [ ] Mandatory CMK encryption for data in transit, intermediate state, and job logs
- [ ] Least-privilege IAM roles for data access
- [ ] Required `tags` enforced
- [ ] Native offline Terraform test validates job configuration

---

### aws/base_component/bedrock_agent_core: Support Agentic Payment Features

**Priority:** HIGH
**Type:** Feature
**Status:** `backlog`
**Module:** aws/base_component/bedrock_agent_core
**Why:** May 7, 2026 update introduced agentic payment features for Bedrock AgentCore, enabling agents to make purchases using the x402 protocol.

> [!IMPORTANT]
> **Blocker:** Pending AWS Provider support for `payment_configuration` (or equivalent) in `aws_bedrockagentcore_gateway`. Verified still blocked in June 2026 provider audit. (Verified by Navigator 2026-06-12)

#### Acceptance Criteria
- [ ] Implement `payment_configuration` block in `aws_bedrockagentcore_gateway`
- [ ] Support for x402 protocol configuration
- [ ] Mandatory CMK encryption for transaction logs/data
- [ ] Required `tags` enforced
- [ ] Native offline Terraform test validates payment configuration

---

### aws/base_component/amazon_quick: Opinionated Amazon Quick module

**Priority:** HIGH
**Type:** Feature
**Status:** `backlog`
**Module:** aws/base_component/amazon_quick
**Why:** Standardized infrastructure for Amazon Quick AI assistant integrations. Includes cross-account Athena data sources, desktop app preview, and "Generate Analysis" capabilities.

> [!IMPORTANT]
> **Blocker:** Pending AWS Provider support for `aws_amazon_quick` (or equivalent) resource. Verified still blocked in June 2026 provider audit. (Verified by Navigator 2026-06-12)

#### Acceptance Criteria
- [ ] `aws_amazon_quick` resource implementation
- [ ] Support for cross-account Athena data sources and data perimeter integration
- [ ] Support for desktop app integration (access to local files, calendar, and communications)
- [ ] Support for "Generate Analysis" (natural language dashboard generation) and visual asset generation
- [ ] Support for expanded native connectors (Google Workspace, Zoom, Airtable, Dropbox, MS Teams)
- [ ] Support for "Custom Apps" preview for building intelligent dashboards and web pages
- [ ] Mandatory CMK encryption for all data stores, logs, and assets created in research sessions, such as analyses
- [ ] Required `tags` enforced
- [ ] Native offline Terraform test validates security and configuration

---

### aws/workload_component/genai_agent_workspace: GenAI Agent Collaborative Workspace pattern

**Priority:** HIGH
**Type:** Feature
**Status:** `backlog`
**Module:** aws/workload_component/genai_agent_workspace
**Why:** Strategic composition of Bedrock AgentCore and Amazon Quick to provide a standardized, secure environment for autonomous agent collaboration and analytics.

> [!IMPORTANT]
> **Blocker:** Pending implementation of prerequisite `aws/base_component/amazon_quick` module.

#### Acceptance Criteria
- [ ] Composes `aws/base_component/bedrock_agent_core` (Gateways)
- [ ] Composes `aws/base_component/amazon_quick` (Assistant and Analytics)
- [ ] Composes `aws/base_component/s3` for shared document storage
- [ ] Mandatory CMK encryption for all shared data at rest
- [ ] Least-privilege IAM roles for cross-service collaboration
- [ ] Required `tags` enforced across all composed resources
- [ ] Mandatory Bedrock Guardrail association for all workspace agents
- [ ] Native offline Terraform test validates the end-to-end composition

---

### aws/base_component/sagemaker_inference: Optimized GenAI Inference Recommendations module

**Priority:** HIGH
**Type:** Feature
**Status:** `backlog`
**Module:** aws/base_component/sagemaker_inference
**Why:** Leverages new "Optimized Generative AI Inference Recommendations" feature (GA April 2026) to automatically identify optimized deployment configurations for generative AI models.

> [!IMPORTANT]
> **Blocker:** Pending AWS Provider support for `aws_sagemaker_inference_recommendations_job` resource. Verified still blocked in June 2026 provider audit. (Verified by Navigator 2026-06-12)

#### Acceptance Criteria
- [ ] `aws_sagemaker_inference_recommendations_job` or equivalent for optimized deployment
- [ ] Support for specifying model, instance type, and inference parameters
- [ ] Mandatory CMK encryption for model artifacts and endpoint logs
- [ ] Placed in VPC private subnets
- [ ] Required `tags` enforced
- [ ] Outputs: `endpoint_arn`, `recommendation_id`
- [ ] Native offline Terraform test validates security settings and VPC placement

---

### aws/base_component/devops_agent: Opinionated AWS DevOps Agent module

**Priority:** HIGH
**Type:** Feature
**Status:** `backlog`
**Module:** aws/base_component/devops_agent
**Why:** AWS DevOps Agent (GA May 2026) is an autonomous "frontier agent" for incident investigation and SRE tasks. Standardizing "Spaces" and MCP integrations is key for platform operations.

> [!IMPORTANT]
> **Blocker:** Pending AWS Provider support for `aws_devopsagent_space` (or equivalent) resource. Verified still blocked in June 2026 provider audit. (Verified by Navigator 2026-06-12)

#### Acceptance Criteria
- [ ] `aws_devopsagent_space` resource implementation
- [ ] Support for defining investigation scope (CloudWatch, GitHub, Azure, etc.)
- [ ] Support for multicloud incident correlation (AWS and Azure) and on-premises investigation via MCP
- [ ] Support for MCP (Model Context Protocol) tool integration
- [ ] Mandatory CMK encryption for all data at rest and logs
- [ ] Required `tags` enforced
- [ ] Native offline Terraform test validates space configuration and security

---

### aws/workload_component/agentic_sre: Secure Agentic SRE pattern

**Priority:** HIGH
**Type:** Feature
**Status:** `backlog`
**Module:** aws/workload_component/agentic_sre
**Why:** Composes AWS DevOps Agent with CloudWatch and Slack (via MCP) to provide an end-to-end autonomous incident response solution.

> [!IMPORTANT]
> **Blocker:** Pending implementation of prerequisite `aws/base_component/devops_agent` module.

#### Acceptance Criteria
- [ ] Composes `aws/base_component/devops_agent`
- [ ] Integrates with CloudWatch for automated incident triggers
- [ ] Configures Slack MCP agent for notifications and human-in-the-loop approvals
- [ ] Least-privilege IAM roles for cross-service and cross-tool investigation
- [ ] Mandatory CMK encryption for all session data and logs
- [ ] Required `tags` enforced across all composed resources
- [ ] Native offline Terraform test validates the end-to-end orchestration

---

## Review-Discovered Improvement Queue

***

## Existing Completed Module History

### aws/base_component/bedrock_agent_core: Expanded support for Online Evaluation, Browsers, and Targets

**Priority:** HIGH
**Type:** Feature
**Status:** `done` (Verified 2026-06-03)
**Module:** aws/base_component/bedrock_agent_core
**Why:** Expanded the base module to support continuous performance monitoring (Online Evaluation), browser-based task execution, and gateway target orchestration for tool management.

#### Acceptance Criteria
- [x] Support for `aws_bedrockagentcore_online_evaluation_config`
- [x] Support for `aws_bedrockagentcore_browser` (sandboxed VPC execution)
- [x] Support for `aws_bedrockagentcore_gateway_target`
- [x] Mandatory CMK encryption for Gateway and Recordings
- [x] Required `tags` enforced
- [x] Native offline Terraform test validates all new resources

---

### aws/base_component/aurora_postgresql: Restore Vector Search and Hardening

**Priority:** HIGH
**Type:** Refactor
**Status:** `done` (Verified 2026-06-03)
**Module:** aws/base_component/aurora_postgresql
**Why:** Restored parameter group configurations for `pgvector`, `aws_lambda`, and `aws_s3`, and enforced storage/backup defaults.

#### Acceptance Criteria
- [x] Restore `aws_rds_cluster_parameter_group` with `rds.allowed_extensions = "pgvector,aws_lambda,aws_s3"`
- [x] Enforce `storage_type = "aurora-iopt1"` and `backup_retention_period = 7` as organizational defaults
- [x] Re-implement `rds_lambda_role` and `aws_rds_cluster_role_association` for Lambda integration
- [x] Native offline Terraform test validates parameter group and IAM association

---

### aws/base_component/observability_admin: Support Organization-level rules

**Priority:** MEDIUM
**Type:** Feature
**Status:** `done` (Verified 2026-06-03)
**Module:** aws/base_component/observability_admin
**Why:** Expanded the module to support organizational telemetry rules using `aws_observabilityadmin_telemetry_rule_for_organization`.

#### Acceptance Criteria
- [x] Support `aws_observabilityadmin_telemetry_rule_for_organization` resource
- [x] Add `is_organization_rule` toggle to the module
- [x] Update outputs to handle both local and organizational rule IDs using `try()`
- [x] Native offline Terraform test validates organizational rule configuration

---

### aws/base_component/aurora_postgresql: Opinionated Aurora PostgreSQL module with Vector Search

**Priority:** HIGH
**Type:** Feature
**Status:** `done` (PR #81)
**Module:** aws/base_component/aurora_postgresql
**Why:** Support for billion-scale vector queries using SQL (announced May 2026). Enables combining vector similarity results with relational filters, a key requirement for advanced RAG and commerce patterns.

#### Acceptance Criteria
- [x] `aws_rds_cluster` with `engine = "aurora-postgresql"` and `engine_version` >= 16.0
- [x] Configure `aws_rds_cluster_parameter_group` to enable `s3_import` and `vector_search` features
- [x] Implement `aws_rds_cluster_role_association` for S3 access (Vector Search)
- [x] Mandatory CMK encryption for storage (`kms_key_id`) and CloudWatch logs
- [x] Placed in VPC private subnets with dedicated `aws_db_subnet_group`
- [x] Point-in-time recovery (PITR) enabled with `backup_retention_period` >= 7
- [x] Storage type `aurora-iopt1` (I/O-Optimized) enabled by default for billion-scale performance
- [x] Required `tags` enforced
- [x] Native offline Terraform test validates encryption, VPC placement, and role association

---

### aws/base_component/observability_admin: Opinionated Observability Admin module

**Priority:** MEDIUM
**Type:** Feature
**Status:** `done` (PR #81)
**Module:** aws/base_component/observability_admin
**Why:** Manage telemetry rules across the organization (introduced in AWS Provider v6.45.0). Standardizes telemetry collection and filtering for better observability posture.

#### Acceptance Criteria
- [x] `aws_observabilityadmin_telemetry_rule` resource implementation
- [x] Support for defining telemetry collection and filtering rules via `telemetry_configuration`
- [x] Support for organizational-level rules via `aws_observabilityadmin_telemetry_rule_for_organization` (added in v6.46.0)
- [x] Mandatory CMK encryption for any underlying log groups or data stores
- [x] Required `tags` enforced
- [x] Native offline Terraform test validates rule configuration and organization-level association

---

### repo-wide: Enforce IMDSv2 across compute modules

**Priority:** HIGH
**Type:** Security
**Status:** `done` (Verified 2026-05-22)
**Module:** repo-wide (Impacts: ec2, asg)
**Why:** Audit on 2026-05-22 identified that while READMEs claimed IMDSv2 enforcement, the underlying `metadata_options` blocks were missing from the `ec2` and `asg` base modules.

#### Acceptance Criteria
- [x] Add `metadata_options` with `http_tokens = "required"` to `aws_instance` in `ec2`
- [x] Add `metadata_options` with `http_tokens = "required"` to `aws_launch_template` in `asg`
- [x] Verify configuration via native `terraform test`

---

### repo-wide: Audit May 2026 Service Lifecycle Updates

**Priority:** LOW
**Type:** Maintenance
**Status:** `done` (PR #80)
**Module:** repo-wide
**Why:** Several AWS services entered maintenance or sunset on April 30, 2026 (App Runner, ARC Readiness Check, RDS Custom for Oracle). Need to audit the library to de-prioritize or archive related modules.

#### Acceptance Criteria
- [x] Identify any modules or examples using App Runner or ARC Readiness Check.
- [x] Mark affected modules as `deprecated` or `maintenance-only` in READMEs. (N/A - no usage found)
- [x] Remove de-prioritized items from the active roadmap.

---

### repo-wide: Security Response for "Copy.fail" and "Dirty Frag" Kernel Vulnerabilities

**Priority:** CRITICAL
**Type:** Security
**Status:** `done` (Verified 2026-05-20)
**Module:** repo-wide (Impacts: ec2, asg, eks)
**Why:** Address critical Linux kernel vulnerabilities (CVE-2026-31431 "Copy.fail", CVE-2026-43284/43500 "Dirty Frag") disclosed in late April and May 2026. These allow local privilege escalation to root.

#### Acceptance Criteria
- [x] Audit `aws/base_component/ec2`, `aws/base_component/asg`, and `aws/base_component/eks` for AMI selection patterns
- [x] Update module READMEs to mandate patched platform versions:
  - [x] Amazon Linux 2023: AL2023.4.20260515.0 or later
  - [x] Bottlerocket: v1.19.2 or later
  - [x] EKS Optimized AMI: 20260515 or later
- [x] Ensure modules support dynamic AMI selection (SSM parameters) to facilitate rapid patching
- [x] Native offline Terraform test validates that AMI inputs are configurable and documented

---

### repo-wide: Security: Kernel Patching (Copy.fail)

**Priority:** HIGH
**Type:** Security
**Status:** `done` (Verified 2026-05-20)
**Module:** repo-wide
**Why:** Critical security response for "Copy.fail" (DirtyFrag) kernel vulnerabilities. Patched AMIs and platform versions for Bottlerocket, ECS-optimized, EKS-optimized, and Fargate are scheduled for release starting May 19, 2026.

#### Acceptance Criteria
- [x] Audit all compute modules (`ec2`, `asg`, `eks`, `ecs_fargate`) for hardcoded or default AMI/Platform versions.
- [x] Update default AMIs to patched versions.
- [x] Verify that new deployments use patched infrastructure.
- [x] Update documentation to recommend immediate rotation of existing compute instances.

---

### aws/base_component/cloudtrail: Opinionated CloudTrail module

**Priority:** HIGH
**Type:** Security
**Status:** `done` (PR #63)
**Module:** aws/base_component/cloudtrail
**Why:** Standardizes organizational audit logging with mandatory CMK encryption, multi-region support, and log file validation.

#### Acceptance Criteria
- [x] `aws_cloudtrail` resource implementation
- [x] Multi-region and global service events enabled by default
- [x] Mandatory CMK encryption for logs
- [x] Mandatory log file validation enabled (`enable_log_file_validation = true`)
- [x] CloudWatch Logs integration support
- [x] Required `tags` enforced
- [x] Native offline Terraform test validates encryption and security settings

---

### aws/base_component/bedrock_guardrail: Opinionated Bedrock Guardrail module

**Priority:** HIGH
**Type:** Security
**Status:** `done` (PR #62)
**Module:** aws/base_component/bedrock_guardrail
**Why:** Bedrock Guardrails provide a critical safety layer for LLM applications, filtering harmful content, blocking topics, and masking PII. Standardizing this is essential for organizational GenAI adoption.

#### Acceptance Criteria
- [x] `aws_bedrock_guardrail` resource implementation
- [x] Support for all six safety layers: Content Filters, Denied Topics, Word Filters, PII Filters, Contextual Grounding, and Prompt Attack Detection
- [x] Support for `aws_bedrock_guardrail_version` to enable immutable safety baselines
- [x] Mandatory CMK encryption for all data stores and logs
- [x] Required `tags` enforced
- [x] Native offline Terraform test validates:
  - [x] Content filter strength configurations
  - [x] PII masking and sensitive word filters
  - [x] Contextual grounding thresholds
  - [x] Mandatory CMK and tagging compliance

---

### aws/base_component/elasticache: Support Valkey 9.0 engine

**Priority:** HIGH
**Type:** Feature
**Status:** `done` (PR #62)
**Module:** aws/base_component/elasticache
**Why:** Valkey 9.0 (announced May 2026) offers significant performance improvements and built-in search capabilities. Supporting this engine is critical for low-latency AI and analytics workloads.

#### Acceptance Criteria
- [x] Support `engine = "valkey"` and `engine_version = "9.0"` in `aws_elasticache_replication_group`
- [x] Validate compatibility with existing CMK and VPC placement defaults
- [x] Support for full-text and hybrid search configurations (if applicable via provider)
- [x] Required `tags` enforced
- [x] Native offline Terraform test validates Valkey configuration

---

### aws/base_component/bedrock_agent: Support Guardrail association

**Priority:** HIGH
**Type:** Security
**Status:** `done` (PR #62)
**Module:** aws/base_component/bedrock_agent
**Why:** Following the May 2026 safety updates, agents should be associated with Guardrails to ensure consistent safety posture during autonomous orchestration.

#### Acceptance Criteria
- [x] Support `guardrail_configuration` block in `aws_bedrockagent_agent`
- [x] Support for specifying `guardrail_identifier` and `guardrail_version`
- [x] Update documentation to highlight the safety-first agent pattern
- [x] Required `tags` enforced
- [x] Native offline Terraform test validates Guardrail association

---


### aws/workload_component/lambda_powertools: Standardized Lambda with Powertools

**Priority:** HIGH
**Type:** Feature
**Status:** `done` (PR #62)
**Module:** aws/workload_component/lambda_powertools
**Why:** Standardizes serverless observability (logging, metrics, tracing) using AWS Lambda Powertools. Promoted from future ideas to ensure high-quality, observable serverless patterns.

#### Acceptance Criteria
- [x] Composes `aws/base_component/lambda`
- [x] Integrates Lambda Powertools Layer (via ARN or managed resource)
- [x] Configures opinionated environment variables for Powertools (LOG_LEVEL, POWERTOOLS_SERVICE_NAME, etc.)
- [x] Mandatory CMK encryption for CloudWatch Logs
- [x] Required `tags` enforced
- [x] Native offline Terraform test validates Powertools configuration and security defaults

---

### aws/base_component/lambda: Support for mounting S3 buckets as file systems

**Priority:** MEDIUM
**Type:** Feature
**Status:** `done` (PR #63)
**Module:** aws/base_component/lambda
**Why:** AWS Provider 6.45.0 (May 13, 2026) introduced support for mounting S3 buckets as file systems with S3 Files.

#### Acceptance Criteria
- [x] Support for `file_system_config` with S3 ARNs in `aws_lambda_function`
- [x] Automatically handle necessary S3 IAM permissions for the execution role
- [x] Required `tags` enforced
- [x] Native offline Terraform test validates S3 mounting and IAM configuration

---

### aws/base_component/bedrock_agent_core: Bedrock AgentCore module

**Priority:** HIGH
**Type:** Feature
**Status:** `done` (PR #60)
**Module:** aws/base_component/bedrock_agent_core
**Why:** Following the May 4, 2026 announcement, Bedrock AgentCore provides enhanced capabilities for building and managing autonomous agents with improved control and visibility. Support confirmed in AWS Provider >= 6.27.0.

#### Acceptance Criteria
- [x] `aws_bedrockagentcore_gateway` resource implementation
- [x] Support for advanced control loops and enhanced visibility into agent reasoning
- [x] Support for autonomous agent orchestration
- [x] Mandatory CMK encryption for all data stores and logs
- [x] Required `tags` enforced
- [x] Native offline Terraform test validates security and configuration

---

### aws/base_component/vpc_lattice: Opinionated VPC Lattice module

**Priority:** HIGH
**Type:** Feature
**Status:** `done` (Verified 2026-05-14)
**Module:** aws/base_component/vpc_lattice
**Why:** VPC Lattice simplifies service-to-service connectivity and security across accounts and VPCs. It is a critical component for modern microservices and cross-team collaboration.

#### Acceptance Criteria
- [x] `aws_vpclattice_service_network` with configurable auth type
- [x] `aws_vpclattice_service` with mandatory CMK for logs (if supported)
- [x] `aws_vpclattice_service_network_vpc_association` support
- [x] `aws_vpclattice_auth_policy` with least-privilege defaults
- [x] Required `tags` enforced across all resources
- [x] Native offline Terraform test validates configuration and associations

---

### aws/base_component/glue: Opinionated AWS Glue module

**Priority:** HIGH
**Type:** Feature
**Status:** `done` (PR #61)
**Module:** aws/base_component/glue
**Why:** Foundational data catalog and ETL primitive. Required for centralizing metadata and preparing data for analytics and GenAI workloads.

#### Acceptance Criteria
- [x] `aws_glue_catalog_database` creation
- [x] `aws_glue_catalog_table` support
- [x] `aws_glue_crawler` with mandatory CMK encryption for results and security configurations
- [x] `aws_glue_job` with VPC placement support and CMK-encrypted logs
- [x] Required `tags` enforced
- [x] Native offline Terraform test validates encryption and catalog settings

---

### aws/workload_component/glue_etl_pattern: Secure Glue ETL pattern

**Priority:** MEDIUM
**Type:** Feature
**Status:** `done` (Verified 2026-05-14)
**Module:** aws/workload_component/glue_etl_pattern
**Why:** Composes S3, Glue, and IAM into a secure data processing pipeline. Demonstrates best practices for data lake ingestion and transformation.

#### Acceptance Criteria
- [x] Uses `aws/base_component/s3` for raw and processed data stores
- [x] Uses `aws/base_component/glue` for metadata catalog and ETL jobs
- [x] IAM roles follow strict least-privilege (scoped to specific S3 buckets and Glue databases)
- [x] Mandatory CMK encryption for all data at rest and logs
- [x] Required `tags` enforced across all composed resources
- [x] Native offline Terraform test validates end-to-end security posture

---

### aws/workload_component/multicloud_hub: Enterprise Multicloud Networking pattern

**Priority:** HIGH
**Type:** Feature
**Status:** `done` (PR #55)
**Module:** aws/workload_component/multicloud_hub
**Why:** Composes `aws_interconnect` with Transit Gateway to provide a standardized regional hub for cross-cloud connectivity (OCI/Azure) with route propagation and security monitoring.

#### Acceptance Criteria
- [x] Uses `aws/base_component/aws_interconnect` for L3 connectivity
- [x] Integrates with `aws_ec2_transit_gateway` for regional routing
- [x] Supports cross-cloud route propagation via BGP
- [x] Mandatory MACsec encryption enforced at the connection layer
- [x] Required `tags` enforced
- [x] Outputs: `tgw_id`, `dx_gateway_id`, `hub_arn`
- [x] Native offline Terraform test validates route table and interconnect wiring

---

### aws/base_component/backup: Opinionated AWS Backup module

**Priority:** HIGH
**Type:** Feature
**Status:** `done` (PR #54)
**Module:** aws/base_component/backup
**Why:** Provides a standardized way to manage backup plans, vaults, and selections for organizational compliance and disaster recovery.

#### Acceptance Criteria
- [x] `aws_backup_vault` with mandatory CMK encryption
- [x] `aws_backup_vault_lock_configuration` support for immutable backups
- [x] `aws_backup_plan` with configurable rules (schedule, retention, lifecycle)
- [x] `aws_backup_selection` using tags or resource ARNs
- [x] Mandatory IAM role via base IAM module
- [x] Required `tags` enforced
- [x] Outputs: `vault_arn`, `plan_id`, `vault_id`
- [x] Native offline Terraform test validates encryption and lock settings

---

### repo-wide: Fix AWS Provider 6.0 deprecation warnings

**Priority:** HIGH
**Type:** Maintenance
**Status:** `done` (PR #43)
**Module:** repo-wide
**Why:** Audit on 2026-05-07 identified remaining uses of `data.aws_region.current.name`. AWS Provider 6.0 standardizes on `.id` for the region name to avoid deprecation warnings.

#### Acceptance Criteria
- [x] Update `aws/workload_component/step_functions_lambda/main.tf` to use `data.aws_region.current.id`
- [x] Update `aws/workload_component/alb_ecs_fargate/main.tf` to use `data.aws_region.current.id`
- [x] Update `aws/base_component/ecs_fargate/main.tf` to use `data.aws_region.current.id`
- [x] Verify all tests pass without deprecation warnings

---

### aws/base_component/account_security: Migrate GuardDuty to Feature resources

**Priority:** MEDIUM
**Type:** Maintenance
**Status:** `done` (PR #49)
**Module:** aws/base_component/account_security
**Why:** The `datasources` block in `aws_guardduty_detector` is deprecated. Migrating to `aws_guardduty_detector_feature` resources aligns with AWS and Terraform provider best practices.

#### Acceptance Criteria
- [x] Refactor `aws_guardduty_detector` to remove the `datasources` block
- [x] Implement `aws_guardduty_detector_feature` resources for S3 Logs, Kubernetes, and Malware Protection
- [x] Ensure parity with current functionality
- [x] Update tests to validate new resource structure

---

### aws/base_component/bedrock_agent: Support granular cost attribution

**Priority:** HIGH
**Type:** Feature
**Status:** `done` (PR #42)
**Module:** aws/base_component/bedrock_agent
**Why:** April 2026 update enables granular cost attribution for Bedrock. Tagging agents allows AI spend to be charged back to individual IAM principals, teams, and projects.

#### Acceptance Criteria
- [x] Ensure all Bedrock Agent resources support and propagate tags for cost attribution
- [x] Validate that tagging correctly attributes costs in usage reports (where testable)
- [x] Update documentation to highlight cost attribution via tagging
- [x] Required `tags` enforced
- [x] Native offline Terraform test validates tag enforcement

---

### aws/base_component/bedrock_knowledge_base: Support granular cost attribution

**Priority:** HIGH
**Type:** Feature
**Status:** `done` (PR #42)
**Module:** aws/base_component/bedrock_knowledge_base
**Why:** April 2026 update enables granular cost attribution for Bedrock. Tagging knowledge bases allows AI spend to be charged back to individual IAM principals, teams, and projects.

#### Acceptance Criteria
- [x] Ensure all Bedrock Knowledge Base resources support and propagate tags for cost attribution
- [x] Update documentation to highlight cost attribution via tagging
- [x] Required `tags` enforced
- [x] Native offline Terraform test validates tag enforcement

---

### tests: Update all modules to follow the new testing standard

**Priority:** HIGH
**Type:** Testing
**Status:** `done` (PR #28)
**Module:** repo-wide
**Why:** Audit on 2026-05-01 revealed that while most modules have tests, 29 modules still lack mandatory assertions for tagging (`environment`, `owner`, `project`, `cost_center`).

#### Acceptance Criteria
- [x] Update `aws/base_component/` tests (Batch 1): account_security, acm, asg, cloudfront, cloudwatch_alarm, dynamodb, ec2, ecr, ecs_fargate, efs
- [x] Update `aws/base_component/` tests (Batch 2): eks, elasticache, eventbridge, rds, route53, secrets_manager, security_group, sns, sqs, ssm, subnet, vpc, vpc_endpoints, wafv2
- [x] Update `aws/workload_component/` tests: alb_ecs_fargate, apigw_lambda, eventbridge_lambda, s3_lambda_trigger, step_functions_lambda

***

### repo-wide: Standardize README structure across all modules

**Priority:** MEDIUM
**Type:** Documentation
**Status:** `done` (PR #11)
**Module:** repo-wide
**Why:** A consistent README structure improves downstream usability and makes Steward review simpler and more objective.

#### Acceptance Criteria
- [x] Define a standard README template with a specific header sequence: Purpose, Usage, Security, Variables, Outputs
- [x] Require HCL usage examples to be valid code snippets
- [x] Add backlog follow-up items for modules that do not meet the new template

### README: Update all modules to follow the new README template

**Priority:** MEDIUM
**Type:** Documentation
**Status:** `done` (PR #12)
**Module:** repo-wide
**Why:** All existing modules currently lack the "Purpose" and "Security" headers in their READMEs as per the new standard defined in `DOCS_TEMPLATE.md`.

#### Acceptance Criteria
- [x] Update `aws/base_component/*` READMEs to include Purpose, Usage, Security, Variables, and Outputs sections in order.
- [x] Update `aws/workload_component/*` READMEs to include Purpose, Usage, Security, Variables, and Outputs sections in order.

***

### repo-wide: Normalize legacy security backlog items

**Priority:** HIGH
**Type:** Maintenance
**Status:** `done` (PR #11)
**Module:** repo-wide
**Why:** The backlog currently mixes completed module work with older security backlog entries that may no longer be accurate. This creates confusion for Navigator, Builder, and Steward.

#### Acceptance Criteria
- [x] Audit all modules against `SEC-001` (KMS CMK enforcement)
- [x] Audit `account_security` module against CIS AWS Foundations Benchmark v3.0
- [x] Remove or update entries that are already satisfied by completed module work
- [x] Convert any still-relevant items into precise module-specific backlog items

---

### repo-wide: Standardize native Terraform tests across all modules

**Priority:** HIGH
**Type:** Testing
**Status:** `done` (PR #12)
**Module:** repo-wide
**Why:** Tests are critical to safe reuse of these modules. A consistent minimum test standard will help Builder create stronger tests and Steward review them consistently.

#### Acceptance Criteria
- [x] Define a minimum native `terraform test` standard (e.g., `tests/main.tftest.hcl` must exist)
- [x] Ensure all tests use mock providers to allow offline execution in CI
- [x] Validate mandatory tags (`environment`, `owner`, `project`, `cost_center`) in every `tftest.hcl`
- [x] Validate CMK encryption for all data-at-rest resources in every `tftest.hcl`
- [x] Add backlog follow-up items for modules that fall short of the new test baseline
- [x] Update repository root `CONTRIBUTING.md` or similar with the testing standard

---

### aws/base_component/bedrock_knowledge_base: Opinionated Bedrock Knowledge Base module

**Priority:** HIGH
**Type:** Feature
**Status:** `done` (PR #24)
**Module:** aws/base_component/bedrock_knowledge_base
**Why:** Critical for RAG (Retrieval-Augmented Generation) patterns. Complements the Bedrock Agent module by providing a managed data source for LLM augmentation.

#### Acceptance Criteria
- [x] `aws_bedrockagent_knowledge_base` with configurable storage type (OpenSearch Serverless, Pinecone, etc.)
- [x] Mandatory CMK encryption for data in transit and at rest (delegated to storage/source)
- [x] Integration with `aws/base_component/s3` for data source ingestion
- [x] Required `tags` enforced
- [x] Outputs: `knowledge_base_id`, `knowledge_base_arn`
- [x] Native offline Terraform test validates encryption and storage settings

---

### repo-wide: AWS Provider 6.0 Migration (Audit & Strategy)

**Priority:** HIGH
**Type:** Maintenance
**Status:** `done` (Verified 2026-05-05)
**Module:** repo-wide
**Why:** AWS Provider 6.0 introduces native `region` attribute support, simplifying multi-region patterns.

#### Acceptance Criteria
- [x] Review `region` attribute injection impact on existing base modules
- [x] Identify multi-region candidates for immediate simplification
- [x] Update library-wide `versions.tf` standard template to `">= 5.0, < 7.0"`
- [x] Audit all modules for breaking changes (nullable booleans, deprecated resources)
- [x] Update documentation to reflect the new `region` attribute standard

---

### repo-wide: Implementation: Migrate foundational modules to AWS Provider 6.0

**Priority:** CRITICAL
**Type:** Maintenance
**Status:** `done` (Verified 2026-05-05)
**Module:** repo-wide
**Why:** Foundational modules updated to support the native `region` attribute.

#### Acceptance Criteria
- [x] Update `aws/base_component/` modules (iam, kms, s3, vpc, route53, acm)
- [x] Update `aws/workload_component/static_website`
- [x] Ensure all tests pass with the new provider version

---

### aws/base_component/acm: Enhance ACM module for Provider 6.0 region support

**Priority:** MEDIUM
**Type:** Maintenance
**Status:** `done` (PR #15)
**Module:** aws/base_component/acm
**Why:** Enables CloudFront us-east-1 certificates via native `region` attribute.

#### Acceptance Criteria
- [x] Update `versions.tf` to support AWS Provider 6.0
- [x] Expose `region` variable in `variables.tf`
- [x] Pass `region` attribute to `aws_acm_certificate`
- [x] Update `aws/workload_component/static_website` to use regional certificate
- [x] Native offline Terraform test validates regional intent

---

### aws/base_component/opensearch_serverless: Opinionated OpenSearch Serverless module

**Priority:** HIGH
**Type:** Feature
**Status:** `done` (PR #13)
**Module:** aws/base_component/opensearch_serverless
**Why:** Scalable vector database for RAG patterns.

#### Acceptance Criteria
- [x] `aws_opensearchserverless_collection` with `type = "VECTORSEARCH"`
- [x] Mandatory CMK encryption
- [x] Network access restricted to VPC
- [x] Data access scoped to least-privilege
- [x] Required `tags` enforced

---

### aws/base_component/eventbridge_pipes: Opinionated EventBridge Pipes module

**Priority:** MEDIUM
**Type:** Feature
**Status:** `done` (Verified 2026-05-03)
**Module:** aws/base_component/eventbridge_pipes
**Why:** Serverless event routing without custom Lambda "glue".

#### Acceptance Criteria
- [x] `aws_pipes_pipe` with source, target, and optional enrichment
- [x] Mandatory IAM execution role created via base IAM module
- [x] Mandatory CMK encryption for SQS DLQs

---

### aws/base_component/securityhub: Opinionated Security Hub module

**Priority:** MEDIUM
**Type:** Feature
**Status:** `done` (Verified 2026-05-03)
**Module:** aws/base_component/securityhub
**Why:** Standardizes enablement and cross-region finding aggregation.

#### Acceptance Criteria
- [x] `aws_securityhub_account` enabled
- [x] `aws_securityhub_finding_aggregator` for cross-region aggregation
- [x] Support for Provider 6.0 `region` attribute

---

### aws/workload_component/centralized_logging: Secure Centralized Logging pattern

**Priority:** MEDIUM
**Type:** Feature
**Status:** `done` (PR #15)
**Module:** aws/workload_component/centralized_logging
**Why:** Security Data Lake aggregating ALB, CloudFront, and VPC Flow Logs.

#### Acceptance Criteria
- [x] Uses base S3 and Athena modules
- [x] Standardized bucket policies for log delivery
- [x] CMK encryption enforced

---

### aws/base_component/apigateway_v2: Opinionated API Gateway v2 (HTTP) base module

**Priority:** HIGH
**Type:** Feature
**Status:** `done` (PR #41)
**Module:** aws/base_component/apigateway_v2
**Why:** Standardized HTTP API base for serverless workloads.

#### Acceptance Criteria
- [x] Mandatory CloudWatch access logging with CMK-encrypted Log Group
- [x] Support for custom domain names and CORS
- [x] Native offline Terraform test validation

---

### aws/base_component/sagemaker_inference: Secure SageMaker Inference module

**Priority:** HIGH
**Type:** Feature
**Status:** `done` (PR #41)
**Module:** aws/base_component/sagemaker_inference
**Why:** Secure deployment of foundation and custom models with VPC and CMK.

#### Acceptance Criteria
- [x] Mandatory VPC configuration for models
- [x] Mandatory CMK encryption for endpoint configuration
- [x] IAM execution role follows least-privilege

---

### aws/base_component/aws_interconnect: Standardized AWS Interconnect module

**Priority:** HIGH
**Type:** Feature
**Status:** `done` (PR #41)
**Module:** aws/base_component/aws_interconnect
**Why:** Multicloud L3 networking with MACsec encryption.

#### Acceptance Criteria
- [x] `aws_dx_gateway` and `aws_dx_connection` setup
- [x] Mandatory MACsec encryption (`encryption_mode = "must_encrypt"`)
- [x] Customer BGP ASN validation

---

### aws/workload_component/static_website: S3 + CloudFront + ACM + Route53 pattern

**Priority:** HIGH
**Type:** Feature
**Status:** `done` (Verified 2026-04-29)
**Module:** aws/workload_component/static_website
**Why:** High-demand pattern for hosting frontend SPAs. Composes multiple base components into a secure, performant, and cost-effective hosting solution with TLS and custom domain support.

#### Acceptance Criteria
- [x] Uses `aws/base_component/s3` for origin (OAC/OAI enabled, public access blocked)
- [x] Uses `aws/base_component/cloudfront` for distribution (WAF enabled, TLS 1.2+ forced)
- [x] Uses `aws/base_component/acm` for certificate management
- [x] Uses `aws/base_component/route53` for DNS records (A/AAAA alias to CloudFront)
- [x] Required `tags` enforced across all resources
- [x] Outputs: `cloudfront_domain_name`, `s3_bucket_arn`, `website_url`
- [x] Native offline Terraform test validates the composition and security headers

---

### aws/base_component/athena: Opinionated Athena module

**Priority:** MEDIUM
**Type:** Feature
**Status:** `done` (Verified 2026-04-29)
**Module:** aws/base_component/athena
**Why:** Enables secure, serverless ad-hoc querying of S3 data. Standardizes workgroup settings, encryption of results, and data access patterns.

#### Acceptance Criteria
- [x] `aws_athena_workgroup` with enforced configuration (prevent client-side overrides)
- [x] Mandatory CMK encryption for query results at rest
- [x] `publish_cloudwatch_metrics_enabled = true` by default
- [x] Required `tags` enforced
- [x] Outputs: `workgroup_name`, `workgroup_arn`
- [x] Native offline Terraform test validates workgroup encryption and metric settings

---

### aws/base_component/cognito: Opinionated Cognito User Pool module

**Priority:** HIGH
**Type:** Feature
**Status:** `done` (Verified 2026-04-29)
**Module:** aws/base_component/cognito
**Why:** Essential for modern serverless authentication patterns and a key missing dependency for the `apigw_lambda` JWT authorizer examples.

#### Acceptance Criteria
- [x] `aws_cognito_user_pool` with advanced security settings (CMK for user data is not currently supported by Cognito)
- [x] `aws_cognito_user_pool_client` with secure defaults (no client secret for SPAs, PKCE enabled)
- [x] Advanced security mode enabled (`AUDIT` or `ENFORCED`)
- [x] Required `tags` enforced
- [x] Outputs: `user_pool_id`, `user_pool_arn`, `client_id`
- [x] Native offline Terraform test validates encryption and security settings

---

### aws/base_component/bedrock_agent: Opinionated Bedrock Agent module

**Priority:** MEDIUM
**Type:** Feature
**Status:** `done` (Verified 2026-04-29)
**Module:** aws/base_component/bedrock_agent
**Why:** Responding to 2026 trends in Agentic AI. Provides a secure foundation for autonomous systems on AWS.

#### Acceptance Criteria
- [x] `aws_bedrockagent_agent` with configurable instruction and foundation model
- [x] `aws_bedrockagent_agent_alias` support
- [x] Mandatory CMK encryption for any associated data stores
- [x] IAM roles for agents follow strict least-privilege (no `*` actions)
- [x] Required `tags` enforced
- [x] Outputs: `agent_id`, `agent_arn`, `agent_alias_id`
- [x] Native offline Terraform test validates agent configuration and IAM role scoping

---

Retain previously completed module entries below this line for historical tracking, but keep new implementation planning focused on the active sections above.

### aws/workload_component/step_functions_lambda: Step Functions + Lambda orchestration pattern

**Priority:** HIGH
**Type:** Feature
**Status:** `done` (PR #10)
**Module:** aws/workload_component/step_functions_lambda
**Why:** Valuable orchestration workload for multi-step serverless processes. Reduces custom state machine wiring and promotes repeatable IAM and logging patterns.

#### Acceptance Criteria
- [x] Creates Step Functions state machine with JSON definition input
- [x] Uses one or more `aws/base_component/lambda` modules or compatible existing Lambda ARNs
- [x] IAM role for Step Functions follows least-privilege rules
- [x] CloudWatch logging configured for the state machine using a CMK
- [x] X-Ray tracing enabled
- [x] Required `tags` enforced
- [x] Outputs: `state_machine_arn`, `state_machine_name`, `lambda_function_arns`
- [x] README with orchestration example
- [x] Native offline Terraform test validates state machine, role, and logging configuration

---

### aws/workload_component/alb_ecs_fargate: ALB + ECS Fargate service pattern

**Priority:** HIGH
**Type:** Feature
**Status:** `done` (PR #10)
**Module:** aws/workload_component/alb_ecs_fargate
**Why:** One of the most common production application deployment patterns. Composes ingress, target groups, listeners, ECS service, and networking into a reusable secure default.

#### Acceptance Criteria
- [x] Uses `aws/base_component/ecs_fargate` internally
- [x] Uses `aws/base_component/alb` internally or accepts compatible ALB inputs
- [x] Creates target group and listener rule wiring for the ECS service
- [x] Supports HTTPS listener integration with ACM certificate
- [x] Supports health check configuration
- [x] Required `tags` enforced
- [x] Outputs: `alb_dns_name`, `service_arn`, `target_group_arn`, `listener_arn`
- [x] README with end-to-end example
- [x] Native offline Terraform test validates ECS service and ALB integration

---

### aws/base_component/acm: Opinionated ACM Certificate module

**Priority:** MEDIUM
**Type:** Feature
**Status:** `done` (Verified 2026-04-26)
**Module:** aws/base_component/acm
**Why:** Standardized certificate management with `create_before_destroy` lifecycle and tagging.

#### Acceptance Criteria
- [x] `aws_acm_certificate` with configurable `domain_name`
- [x] `create_before_destroy` lifecycle policy enforced
- [x] Required `tags` enforced
- [x] Outputs: `certificate_arn`

---

### aws/base_component/asg: Opinionated Auto Scaling Group module

**Priority:** HIGH
**Type:** Feature
**Status:** `done` (Verified 2026-04-26)
**Module:** aws/base_component/asg
**Why:** Secure EC2 auto-scaling with mandatory EBS encryption and monitoring.

#### Acceptance Criteria
- [x] `aws_launch_template` with enforced EBS encryption using CMK
- [x] `aws_autoscaling_group` with VPC placement
- [x] Monitoring enabled by default
- [x] Tag propagation to initiatives and volumes
- [x] Required `tags` enforced

---

### aws/base_component/ec2: Opinionated EC2 Instance module

**Priority:** HIGH
**Type:** Feature
**Status:** `done` (Verified 2026-04-26)
**Module:** aws/base_component/ec2
**Why:** Secure single-instance compute with mandatory EBS encryption and monitoring.

#### Acceptance Criteria
- [x] `aws_instance` with enforced root block device encryption using CMK
- [x] Detailed monitoring enabled
- [x] Required `tags` enforced

---

### aws/base_component/efs: Opinionated EFS File System module

**Priority:** HIGH
**Type:** Feature
**Status:** `done` (Verified 2026-04-26)
**Module:** aws/base_component/efs
**Why:** Secure elastic file storage with mandatory encryption and backup policy.

#### Acceptance Criteria
- [x] `aws_efs_file_system` with mandatory CMK encryption
- [x] `aws_efs_backup_policy` set to `ENABLED`
- [x] Required `tags` enforced

---

### aws/base_component/step_functions: Opinionated Step Functions module

**Priority:** MEDIUM
**Type:** Feature
**Status:** `done` (Verified 2026-04-26)
**Module:** aws/base_component/step_functions
**Why:** Orchestration primitive with mandatory logging and tracing.

#### Acceptance Criteria
- [x] `aws_sfn_state_machine` with mandatory CloudWatch logging
- [x] CloudWatch log group encrypted with CMK
- [x] X-Ray tracing enabled
- [x] Required `tags` enforced

---

### aws/base_component/wafv2: Opinionated WAFv2 Web ACL module

**Priority:** HIGH
**Type:** Feature
**Status:** `done` (Verified 2026-04-26)
**Module:** aws/base_component/wafv2
**Why:** Centralized web application firewall with standard rule sets and visibility.

#### Acceptance Criteria
- [x] `aws_wafv2_web_acl` with standard visibility config
- [x] Includes `AWSManagedRulesCommonRuleSet` by default
- [x] Required `tags` enforced

---

### aws/base_component/ecr: Opinionated ECR repository module

**Priority:** HIGH
**Type:** Feature
**Status:** `done` (PR #9)
**Module:** aws/base_component/ecr
**Why:** Foundational container registry module for ECS, EKS, and future workload compositions. Centralizes image scanning, immutable tags, encryption, and lifecycle policy defaults.

#### Acceptance Criteria
- [x] `aws_ecr_repository` with configurable `name`
- [x] Image tag mutability defaults to `IMMUTABLE`
- [x] Image scanning on push enabled by default
- [x] KMS encryption using CMK (`kms_key_arn` input or module-managed key)
- [x] Optional lifecycle policy support for image retention
- [x] Required `tags` enforced
- [x] Outputs: `repository_arn`, `repository_name`, `repository_url`
- [x] README with usage example, inputs, outputs, and security defaults
- [x] Native offline Terraform test validates encryption, scan on push, and immutable tags

#### Security Notes
- Immutable tags should be the default
- Scan on push must be enabled by default
- Encryption must use CMK, not default AES256

***

### aws/base_component/alb: Opinionated Application Load Balancer module

**Priority:** HIGH
**Type:** Feature
**Status:** `done` (PR #9)
**Module:** aws/base_component/alb
**Why:** Foundational ingress and traffic-routing module for ECS and future application patterns. Standardizes TLS posture, access logging, and safe security-group defaults.

#### Acceptance Criteria
- [x] `aws_lb` with `load_balancer_type = "application"`
- [x] Configurable public or internal deployment mode
- [x] Access logging enabled by default to S3
- [x] Security group support with no permissive default ingress
- [x] HTTPS listener support with ACM certificate ARN input
- [x] Optional HTTP-to-HTTPS redirect listener
- [x] Deletion protection configurable and enabled by default for production-style usage
- [x] Required `tags` enforced
- [x] Outputs: `alb_arn`, `alb_dns_name`, `alb_zone_id`, `security_group_id`
- [x] README with example for ECS/Fargate integration
- [x] Native offline Terraform test validates listeners, logging configuration, and tags

#### Security Notes
- Public ALBs should redirect HTTP to HTTPS by default when HTTPS is configured
- Access logs must be enabled by default
- Security groups must not allow unsafe defaults unless explicitly configured

***

### aws/base_component/eventbridge: Opinionated EventBridge module

**Priority:** MEDIUM
**Type:** Feature
**Status:** `done` (PR #9)
**Module:** aws/base_component/eventbridge
**Why:** Foundational event-routing module that supports future workload compositions such as eventbridge_lambda and standardized event-driven architectures.

#### Acceptance Criteria
- [x] Support EventBridge bus creation or use of default bus
- [x] Support rule creation with configurable event pattern or schedule expression
- [x] Support target attachment inputs
- [x] Optional dead-letter queue integration for supported targets
- [x] Required `tags` enforced where supported
- [x] Outputs: `event_bus_name`, `rule_arns`, `target_ids`
- [x] README with examples for scheduled and event-pattern rules
- [x] Native offline Terraform test validates rule creation and target wiring

***

### aws/base_component/cloudwatch_alarm: Opinionated CloudWatch alarms module

**Priority:** MEDIUM
**Type:** Feature
**Status:** `done` (PR #9)
**Module:** aws/base_component/cloudwatch_alarm
**Why:** Reusable observability primitive for consistent alarms across workload modules. Enables safer production defaults and easier composition.

#### Acceptance Criteria
- [x] Support one or more CloudWatch metric alarms with configurable namespace, metric name, statistic, threshold, and period
- [x] Support alarm actions and OK actions inputs
- [x] Support dimensions input map
- [x] Required `tags` enforced where supported
- [x] Outputs: `alarm_arns`, `alarm_names`
- [x] README with Lambda and ECS alarm examples
- [x] Native offline Terraform test validates alarm configuration shape

***

### aws/workload_component/eventbridge_lambda: EventBridge rule + Lambda pattern

**Priority:** HIGH
**Type:** Feature
**Status:** `done` (PR #9)
**Module:** aws/workload_component/eventbridge_lambda
**Why:** Common event-driven workload pattern. Composing EventBridge, Lambda, IAM, logging, and optional DLQ reduces repeated wiring and encourages secure defaults.

#### Acceptance Criteria
- [x] Uses `aws/base_component/lambda` internally
- [x] Creates EventBridge rule from event pattern or schedule expression
- [x] Adds Lambda target and invoke permissions
- [x] Supports optional SQS dead-letter queue for failed delivery
- [x] CloudWatch log group exists with retention configured through the Lambda module
- [x] Required `tags` enforced
- [x] Outputs: `rule_arn`, `function_arn`, `function_name`, `target_id`
- [x] README with scheduled-job and event-pattern usage examples
- [x] Native offline Terraform test validates rule, target, and Lambda permission resources

#### Security Notes
- Least-privilege Lambda execution role only
- No wildcard permissions unless explicitly justified

***

### aws/workload_component/s3_lambda_trigger: S3 event notification + Lambda pattern

**Priority:** HIGH
**Type:** Feature
**Status:** `done` (PR #9)
**Module:** aws/workload_component/s3_lambda_trigger
**Why:** Common ingestion and object-processing pattern. Composes secure S3 defaults with Lambda invocation wiring and reduces repetitive event-notification setup.

#### Acceptance Criteria
- [x] Uses `aws/base_component/s3` and `aws/base_component/lambda` internally, or accepts compatible existing resources
- [x] Configurable bucket event types and object prefix/suffix filters
- [x] `aws_lambda_permission` grants S3 invoke access
- [x] Optional dead-letter queue support for downstream failure handling
- [x] Required `tags` enforced
- [x] Outputs: `bucket_arn`, `function_arn`, `notification_configuration_id`
- [x] README with example for object-created trigger flow
- [x] Native offline Terraform test validates notification configuration and Lambda permission

#### Security Notes
- Bucket must retain secure defaults from the base S3 module
- Lambda execution role must remain least-privilege

***

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
**Status:** `done` (PR #8)
**Module:** aws/workload_component/apigw_lambda
**Why:** The most common serverless pattern in the org. Composing this from base modules eliminates the need for developers to wire up routes, integrations, stages, and Lambda permissions separately.

#### Acceptance Criteria
- [x] Uses `aws/base_component/lambda` module internally (not raw `aws_lambda_function`)
- [x] `aws_apigatewayv2_api` (HTTP API type)
- [x] `aws_apigatewayv2_integration` linked to Lambda function ARN
- [x] `aws_apigatewayv2_route` with configurable route key (e.g., `POST /items`)
- [x] `aws_apigatewayv2_stage` with `auto_deploy = true` and CloudWatch access log group
- [x] `aws_lambda_permission` granting API GW invoke rights
- [x] Optional JWT authorizer: `aws_apigatewayv2_authorizer` with configurable `issuer` and `audience`
- [x] Outputs: `api_endpoint`, `api_id`, `stage_id`, `route_id`, `function_arn`
- [x] Required `tags` enforced
- [x] At least one Terraform test: endpoint returns expected HTTP response

#### Security Notes
- JWT authorizer required for any non-public route — make this the default
- CloudWatch access logging must be enabled by default

---

### aws/workload_component/apigw_lambda: Add JWT Authorizer and WAF

**Priority:** HIGH
**Type:** Security
**Status:** `done` (PR #7)
**Module:** aws/workload_component/apigw_lambda
**Why:** Current implementation lacks mandatory JWT authorization and WAF association, which are organizational security standards for API Gateway.

#### Acceptance Criteria
- [x] Implement JWT authorizer by default
- [x] Add mandatory WAF association

#### Security Notes
- Every API must be protected by an authorizer and WAF unless specifically exempted.

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

### aws/base_component/account_security: Account-level security baseline module

**Priority:** HIGH
**Type:** Security
**Status:** `done` (Verified 2026-04-27)
**Module:** aws/base_component/account_security
**Why:** Provides an account-wide security "safety net" including S3 public access blocks, default security group hardening, and IMDSv2 enforcement.

#### Acceptance Criteria
- [x] `aws_s3_account_public_access_block` enforces account-wide S3 security
- [x] `aws_default_security_group` removes all rules from VPC default security group
- [x] `aws_ec2_instance_metadata_defaults` enforces IMDSv2 and hop limit 1
- [x] `aws_ebs_encryption_by_default` enforces regional disk encryption
- [x] `aws_iam_account_password_policy` enforces strong IAM user passwords
- [x] `aws_accessanalyzer_analyzer` enables external access monitoring
- [x] Required `tags` enforced
- [x] Native offline Terraform test validates configurations
- [x] Outputs: `s3_account_public_block_enabled`, `default_security_group_id`

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
- [x] Outputs: `cluster_arn`, `service_arn`, `task_definition_arn`, `task_role_arn`, `execution_role_arn`
- [x] README documentation matches `variables.tf` and `outputs.tf`
- [x] Terraform test: Cluster and service created with Fargate capacity providers

---

### aws/base_component/cloudfront: Opinionated CloudFront distribution module

**Priority:** HIGH
**Type:** Feature
**Status:** `done` (Verified 2026-04-26)
**Module:** aws/base_component/cloudfront
**Why:** Secure content delivery. Enforces TLS 1.2+, WAF integration, and logging.

#### Acceptance Criteria
- [x] `aws_cloudfront_distribution` with S3 or ALB origin
- [x] Mandatory WAF association
- [x] Access logging to S3 enabled by default
- [x] Minimum protocol version TLSv1.2_2021
- [x] Required `tags` enforced
- [x] Outputs: `distribution_id`, `distribution_arn`, `distribution_domain_name`

---

### aws/base_component/vpc_endpoints: Opinionated VPC Endpoints module

**Priority:** MEDIUM
**Type:** Feature
**Status:** `done` (Verified 2026-04-26)
**Module:** aws/base_component/vpc_endpoints
**Why:** Enables private access to AWS services without NAT gateways.

#### Acceptance Criteria
- [x] Support for S3 and DynamoDB Gateway endpoints
- [x] Support for Interface endpoints (e.g., kms, logs, execute-api)
- [x] Security groups for interface endpoints scoped to VPC CIDR
- [x] Required `tags` enforced
- [x] Outputs: `s3_endpoint_id`, `dynamodb_endpoint_id`, `interface_endpoint_ids`

---

### aws/base_component/subnet: Standalone Subnet module

**Priority:** MEDIUM
**Type:** Feature
**Status:** `done` (Verified 2026-04-26)
**Module:** aws/base_component/subnet
**Why:** For custom network topologies where the standard VPC module is too rigid.

#### Acceptance Criteria
- [x] `aws_subnet` with configurable CIDR and AZ
- [x] `map_public_ip_on_launch` defaults to `false`
- [x] Required `tags` enforced
- [x] Outputs: `subnet_id`, `subnet_arn`

---

### aws/base_component/security_group: Opinionated Security Group module

**Priority:** MEDIUM
**Type:** Feature
**Status:** `done` (Verified 2026-04-26)
**Module:** aws/base_component/security_group
**Why:** Consistent SG management with mandatory descriptions and no 0.0.0.0/0 defaults.

#### Acceptance Criteria
- [x] `aws_security_group` with mandatory `description`
- [x] No default rules (must be explicitly provided)
- [x] Validation: No `0.0.0.0/0` in ingress rules without override
- [x] Required `tags` enforced
- [x] Outputs: `security_group_id`, `security_group_arn`

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

#### Future Roadmap
- [ ] Support managed rotation for Datadog API keys
- [ ] Support managed rotation for Snowflake credentials

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
