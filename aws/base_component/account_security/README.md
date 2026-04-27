# Opinionated Account Security Module

This module enforces account-level and region-level security standards to provide a safe baseline for AWS member accounts operating within an AWS Organization managed by Control Tower.

> **Organization-managed accounts:** CloudTrail, AWS Config, and Security Hub are assumed to be managed centrally by the organization/landing zone. This module does **not** create those resources. It layers additional account-level posture controls on top of the org baseline.

## Purpose

While individual resources (like S3 buckets) should have their own security configurations, this module provides an account-wide "safety net" that prevents accidental exposure even if a resource-level setting is misconfigured. This is intentionally **not** a place for service-specific security — each service module owns its own security posture.

## Features

### Prevent Exposure / Enforce Secure Defaults

- **S3 Account-level Public Access Block**: Enforces `block_public_acls`, `block_public_policy`, `ignore_public_acls`, and `restrict_public_buckets` for the entire AWS account.
- **Default Security Group Hardening**: Removes all ingress and egress rules from the `default` security group of a VPC. Default security groups should never carry actual traffic.
- **EC2 Instance Metadata Defaults**: Enforces IMDSv2 (Session Tokens Required) and sets the hop limit to `1` by default to prevent metadata access from within containers. Requires AWS Provider >= 5.71.0.
- **EBS Encryption by Default**: Enforces that all new EBS volumes and snapshots created in the account/region are encrypted. Optionally accepts a custom KMS key ARN.

### Identity Hardening

- **IAM Account Password Policy**: Enforces strong password requirements for IAM users (min length, complexity, rotation, reuse prevention).
- **IAM Access Analyzer**: Enables continuous monitoring of resource policies to identify resources shared with external entities (other accounts or the internet).

### Threat Detection

- **Amazon GuardDuty**: Account/region-level threat detection across CloudTrail events, VPC Flow Logs, DNS logs, S3 access logs, EKS audit logs, and EBS volumes (malware scanning). Compatible with an org-level GuardDuty delegated admin — member detectors are required even in org-managed setups.

### Account Ownership

- **Alternate Contacts**: Registers designated team contacts (SECURITY, BILLING, OPERATIONS) on the account. CIS Benchmark requires current contact details for all three personas. Use team/group mailboxes rather than individual addresses — contacts are only created when the corresponding email variable is set.

## Org-Managed Account Assumptions

This module is designed for member accounts within an AWS Organization using Control Tower or an equivalent landing zone. The following services are **not** managed by this module because they are owned at the org/landing-zone level:

| Service | Why it's excluded |
|---|---|
| AWS CloudTrail | Org-level trail covers all member accounts |
| AWS Config | Org-level Config recorder and delivery channel |
| AWS Security Hub | Org-level delegated admin manages enablement and standards |

If you are deploying this module in a **standalone** (non-org) account, you will need a separate module or configuration to cover CloudTrail, Config, and Security Hub.

## Usage

```hcl
module "account_security" {
  source = "aws/base_component/account_security"

  # Required
  tags = {
    environment = "production"
    owner       = "platform"
    project     = "core"
    cost_center = "platform-eng"
  }

  # Optional: harden the default VPC security group
  vpc_id = module.vpc.vpc_id

  # Optional: use a custom KMS key for EBS encryption
  ebs_kms_key_arn = module.kms.key_arn

  # Optional: alternate contacts (use team/group mailboxes)
  security_contact_name  = "Security Team"
  security_contact_email = "security@example.com"
  security_contact_phone = "+15555550100"

  billing_contact_name   = "Billing Team"
  billing_contact_email  = "billing@example.com"
  billing_contact_phone  = "+15555550101"

  operations_contact_name  = "Operations Team"
  operations_contact_email = "operations@example.com"
  operations_contact_phone = "+15555550102"
}
```

## Inputs

### General

| Name | Description | Type | Default | Required |
|---|---|---|---|---|
| `tags` | Map of tags to assign to resources | `map(string)` | — | Yes |
| `aws_account_id` | AWS Account ID (used for tests/mocking) | `string` | `null` | No |

### S3 Account-level Public Access Block

| Name | Description | Type | Default |
|---|---|---|---|
| `enable_s3_account_public_block` | Enable account-wide S3 public access block | `bool` | `true` |

### Default Security Group Hardening

| Name | Description | Type | Default |
|---|---|---|---|
| `vpc_id` | VPC whose default security group will be hardened. If null, skipped. | `string` | `null` |

### EC2 Instance Metadata Defaults

| Name | Description | Type | Default |
|---|---|---|---|
| `enable_ec2_metadata_defaults` | Enable account-level IMDSv2 enforcement | `bool` | `true` |
| `ec2_metadata_hop_limit` | HTTP PUT response hop limit (1–64). Best practice: 1. | `number` | `1` |

### EBS Encryption by Default

| Name | Description | Type | Default |
|---|---|---|---|
| `enable_ebs_encryption_by_default` | Enable account-level EBS encryption by default | `bool` | `true` |
| `ebs_kms_key_arn` | KMS key ARN for EBS encryption. If null, uses the default `aws/ebs` key. | `string` | `null` |

### IAM Password Policy

| Name | Description | Type | Default |
|---|---|---|---|
| `enable_iam_password_policy` | Enable the account-level IAM password policy | `bool` | `true` |
| `password_policy_min_length` | Minimum password length. CIS recommends 14+. | `number` | `14` |

### IAM Access Analyzer

| Name | Description | Type | Default |
|---|---|---|---|
| `enable_access_analyzer` | Enable IAM Access Analyzer for the account | `bool` | `true` |

### Amazon GuardDuty

| Name | Description | Type | Default |
|---|---|---|---|
| `enable_guardduty` | Enable GuardDuty for the account/region | `bool` | `true` |
| `enable_guardduty_kubernetes` | Enable GuardDuty Kubernetes Audit Log monitoring. Set to `false` in accounts where EKS is not used. | `bool` | `true` |

### Alternate Contacts

| Name | Description | Type | Default |
|---|---|---|---|
| `security_contact_name` | Full name of the alternate security contact | `string` | `null` |
| `security_contact_email` | Email of the alternate security contact. Contact is created when non-null. | `string` | `null` |
| `security_contact_phone` | Phone of the alternate security contact (E.164 format) | `string` | `null` |
| `security_contact_title` | Title/role of the alternate security contact | `string` | `"Security Team"` |
| `billing_contact_name` | Full name of the alternate billing contact | `string` | `null` |
| `billing_contact_email` | Email of the alternate billing contact. Contact is created when non-null. | `string` | `null` |
| `billing_contact_phone` | Phone of the alternate billing contact (E.164 format) | `string` | `null` |
| `billing_contact_title` | Title/role of the alternate billing contact | `string` | `"Billing Team"` |
| `operations_contact_name` | Full name of the alternate operations contact | `string` | `null` |
| `operations_contact_email` | Email of the alternate operations contact. Contact is created when non-null. | `string` | `null` |
| `operations_contact_phone` | Phone of the alternate operations contact (E.164 format) | `string` | `null` |
| `operations_contact_title` | Title/role of the alternate operations contact | `string` | `"Operations Team"` |

## Outputs

### Exposure / Secure Defaults

| Name | Description |
|---|---|
| `s3_account_public_block_enabled` | Whether the S3 public access block is enabled |
| `default_security_group_id` | ID of the hardened default security group, or null |
| `ec2_metadata_defaults_enabled` | Whether IMDSv2 enforcement is enabled |
| `ebs_encryption_enabled` | Whether EBS encryption by default is enabled |

### Identity Hardening

| Name | Description |
|---|---|
| `iam_password_policy_enabled` | Whether the IAM password policy is enabled |
| `access_analyzer_arn` | ARN of the IAM Access Analyzer, or null |

### Threat Detection

| Name | Description |
|---|---|
| `guardduty_detector_id` | GuardDuty detector ID, or null if disabled |
| `guardduty_detector_arn` | GuardDuty detector ARN, or null if disabled |

### Alternate Contacts

| Name | Description |
|---|---|
| `security_contact_email` | Registered security contact email, or null |
| `billing_contact_email` | Registered billing contact email, or null |
| `operations_contact_email` | Registered operations contact email, or null |

## Continuous Review

> **SEC-008 — CRITICAL:** This module is paramount to your AWS account security posture and must be reviewed on a regular cadence. See `SEC-008` in `.Jules/backlog.md` for the standing review item.

### Checklist

- [ ] Are all controls enabled and not accidentally toggled off in any environment?
- [ ] Has AWS released new account-level security features (e.g., new GuardDuty protection plans)?
- [ ] Are all three alternate contacts (SECURITY, BILLING, OPERATIONS) set to current, reachable team mailboxes?
- [ ] Is the IAM password policy minimum length still meeting your compliance requirements (current: 14)?
- [ ] Are there any IAM users with long-lived access keys that should be rotated or replaced with roles?
- [ ] Is root MFA enabled on the account and are there no root access keys?
- [ ] Is the account placed in the correct OU with the appropriate SCPs applied?
- [ ] Are GuardDuty findings being reviewed and triaged regularly in the org delegated admin account?
- [ ] Is the Access Analyzer showing any unexpected external sharing findings?

### Non-Terraform Security Requirements (per account)

The following cannot be enforced by Terraform but must be validated manually or via your compliance tooling:

- **Root MFA**: Must be enabled on every account. No root access keys should exist.
- **Root usage**: Root should not be used for day-to-day operations. Validate via GuardDuty/CloudTrail findings in the org audit account.
- **IAM users**: Prefer SSO/Identity Center and roles over long-lived IAM users. If IAM users exist, they must use groups for permissions (no direct policy attachments) and rotate access keys regularly.
- **Account OU placement**: Confirm the account is in the correct OU so the right SCPs are inherited from the organization.
