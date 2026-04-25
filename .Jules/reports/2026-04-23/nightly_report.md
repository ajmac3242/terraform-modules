# Sentinel Nightly Report — 2026-04-23

## Summary
- **Modules Scanned:** 30
- **Violations Found:**
  - CRITICAL: 0
  - HIGH: 0
  - MEDIUM: 1 (Hygiene: Support for permissions boundaries in wrapper modules)
  - LOW: 24 (Hygiene: Standardization of 'aws_account_id' for testing)
- **PRs Opened:** 1
- **Issues Filed:** 0

## Modules Scanned
- All base components under `aws/base_component/`
- All workload components under `aws/workload_component/`

## Findings & Actions
### HIGH: Missing Permissions Boundary in Wrapper Modules
Wrapper modules for Lambda, ECS Fargate, and EKS were not passing the `permissions_boundary_arn` variable to the underlying IAM module.
- **Action:** Updated `lambda`, `ecs_fargate`, `eks`, and `apigw_lambda` to support and pass `permissions_boundary_arn`.

### LOW: Standardized 'aws_account_id' for Mocking
Several modules lacked the `aws_account_id` variable, which is necessary for consistent mocking of the AWS account ID in `terraform test`.
- **Action:** Added `aws_account_id` to all remaining modules.

## Pass List (No Security Violations)
- All modules passed data-at-rest encryption (CMK), logging, and networking security audits.
