# aws/base_component/account_security

## Purpose
This module enforces account-level and region-level security standards (CIS AWS Foundations Benchmark v3.0 compliant) to provide a safe baseline for AWS member accounts operating within an AWS Organization managed by Control Tower. While individual resources (like S3 buckets) should have their own security configurations, this module provides an account-wide "safety net" that prevents accidental exposure even if a resource-level setting is misconfigured.

### Org-Managed Account Assumptions
Designed for member accounts within an AWS Organization using Control Tower or an equivalent landing zone. The following services are **not** managed by this module because they are owned at the org/landing-zone level:
- **AWS CloudTrail**: Org-level trail covers all member accounts.
- **AWS Config**: Org-level Config recorder and delivery channel.
- **AWS Security Hub**: Org-level delegated admin manages enablement and standards.

## Usage
```hcl
module "account_security" {
  source = "./aws/base_component/account_security"

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
}
```

## Security
- **Compliance**: Aligned with CIS AWS Foundations Benchmark v3.0 standards.
- **Encryption**: Enforces account-level EBS encryption by default using AWS-managed keys or a provided CMK (`ebs_kms_key_arn`).
- **Exposure Control**: Enforces account-wide S3 Public Access Block, disables EC2 Serial Console access, and hardens the default VPC security group (removes all rules).
- **Identity Hardening**: Enforces a strong IAM password policy, creates the required IAM Support role, and enables IAM Access Analyzer for external access monitoring.
- **Threat Detection**: Enables Amazon GuardDuty (including S3, EKS Audit Logs, and EBS Malware Protection) at the account/region level using granular detector features.
- **Instance Security**: Enforces IMDSv2 (Session Tokens Required) for all new EC2 instances with a hop limit of 1.

### Continuous Review
> **SEC-008 — CRITICAL:** This module is paramount to your AWS account security posture and must be reviewed on a regular cadence. See `SEC-008` in `.Jules/backlog.md` for the standing review item.

- [ ] Are all controls enabled and not accidentally toggled off in any environment?
- [ ] Has AWS released new account-level security features?
- [ ] Are all three alternate contacts set to current, reachable team mailboxes?
- [ ] Is the IAM password policy minimum length still meeting requirements (current: 14)?
- [ ] Is root MFA enabled and root access keys deleted?

## Variables
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `tags` | Map of tags to assign to resources. Required keys: `environment`, `owner`, `project`, `cost_center`. | `map(string)` | n/a | yes |
| `aws_account_id` | AWS Account ID (used for tests/mocking) | `string` | `null` | no |
| `enable_s3_account_public_block` | Enable account-wide S3 public access block | `bool` | `true` | no |
| `vpc_id` | VPC whose default security group will be hardened. If null, skipped. | `string` | `null` | no |
| `enable_ec2_metadata_defaults` | Enable account-level IMDSv2 enforcement | `bool` | `true` | no |
| `ec2_metadata_hop_limit` | HTTP PUT response hop limit (1–64). Best practice: 1. | `number` | `1` | no |
| `enable_ebs_encryption_by_default` | Enable account-level EBS encryption by default | `bool` | `true` | no |
| `ebs_kms_key_arn` | KMS key ARN for EBS encryption. If null, uses the default `aws/ebs` key. | `string` | `null` | no |
| `enable_iam_password_policy` | Enable the account-level IAM password policy | `bool` | `true` | no |
| `password_policy_min_length` | Minimum password length. CIS recommends 14+. | `number` | `14` | no |
| `enable_serial_console_access` | Whether to enable EC2 serial console access. CIS recommends false. | `bool` | `false` | no |
| `create_support_role` | Whether to create the CIS-required IAM Support role | `bool` | `true` | no |
| `enable_access_analyzer` | Enable IAM Access Analyzer for the account | `bool` | `true` | no |
| `enable_guardduty` | Enable GuardDuty for the account/region | `bool` | `true` | no |
| `enable_guardduty_kubernetes` | Enable GuardDuty Kubernetes Audit Log monitoring | `bool` | `true` | no |
| `security_contact_name` | Full name of the alternate security contact | `string` | `null` | no |
| `security_contact_email` | Email of the alternate security contact | `string` | `null` | no |
| `security_contact_phone` | Phone of the alternate security contact | `string` | `null` | no |
| `security_contact_title` | Title/role of the alternate security contact | `string` | `"Security Team"` | no |
| `billing_contact_name` | Full name of the alternate billing contact | `string` | `null` | no |
| `billing_contact_email` | Email of the alternate billing contact | `string` | `null` | no |
| `billing_contact_phone` | Phone of the alternate billing contact | `string` | `null` | no |
| `billing_contact_title` | Title/role of the alternate billing contact | `string` | `"Billing Team"` | no |
| `operations_contact_name` | Full name of the alternate operations contact | `string` | `null` | no |
| `operations_contact_email` | Email of the alternate operations contact | `string` | `null` | no |
| `operations_contact_phone` | Phone of the alternate operations contact | `string` | `null` | no |
| `operations_contact_title` | Title/role of the alternate operations contact | `string` | `"Operations Team"` | no |

## Outputs
| Name | Description |
|------|-------------|
| `s3_account_public_block_enabled` | Whether the S3 public access block is enabled |
| `default_security_group_id` | ID of the hardened default security group |
| `ec2_metadata_defaults_enabled` | Whether IMDSv2 enforcement is enabled |
| `ebs_encryption_enabled` | Whether EBS encryption by default is enabled |
| `iam_password_policy_enabled` | Whether the IAM password policy is enabled |
| `access_analyzer_arn` | ARN of the IAM Access Analyzer |
| `guardduty_detector_id` | GuardDuty detector ID |
| `guardduty_detector_arn` | GuardDuty detector ARN |
| `security_contact_email` | Registered security contact email |
| `billing_contact_email` | Registered billing contact email |
| `operations_contact_email` | Registered operations contact email |
