# Opinionated Account Security Module

This module enforces account-level and region-level security standards to provide a safe baseline for AWS environments. It handles S3 public access blocking, default security group hardening, IMDSv2 enforcement, threat detection, audit logging, and continuous compliance monitoring.

## Purpose

While individual resources (like S3 buckets) should have their own security configurations, this module provides an account-wide "safety net" that prevents accidental exposure even if a resource-level setting is misconfigured. This is intentionally **not** a place for service-specific security — each service module owns its own security posture.

## Features

- **S3 Account-level Public Access Block**: Enforces `block_public_acls`, `block_public_policy`, `ignore_public_acls`, and `restrict_public_buckets` for the entire AWS account.
- **Default Security Group Hardening**: Removes all ingress and egress rules from the `default` security group of a VPC.
- **EC2 Instance Metadata Defaults**: Enforces IMDSv2 (Session Tokens Required) and sets the hop limit to `1` by default to prevent metadata access from within containers.
- **EBS Encryption by Default**: Enforces that all new EBS volumes created in the account/region are encrypted.
- **IAM Account Password Policy**: Enforces strong password requirements for IAM users.
- **IAM Access Analyzer**: Enables continuous monitoring of resource sharing with external entities.
- **Amazon GuardDuty**: Threat detection across CloudTrail, VPC Flow Logs, DNS, S3 access logs, EKS audit logs, and EBS volumes for malware.
- **AWS CloudTrail**: Multi-region, multi-service API audit trail with log file validation, CloudWatch delivery, and optional CMK encryption.
- **AWS Security Hub**: Aggregates findings from GuardDuty, Config, and other services. Subscribes to CIS AWS Foundations Benchmark v1.4.0 and AWS Foundational Security Best Practices by default.
- **AWS Config**: Continuous configuration recording across all supported resource types with delivery to S3.
- **Alternate Security Contact**: Registers the designated security team contact on the account (CIS benchmark requirement).

## Usage

```hcl
module "account_security" {
  source = "aws/base_component/account_security"

  vpc_id = "vpc-12345678"

  # CloudTrail and Config each need a pre-existing S3 bucket
  # (create these with the aws/base_component/s3 module)
  cloudtrail_s3_bucket_name = "my-org-cloudtrail-logs"
  cloudtrail_kms_key_arn    = "arn:aws:kms:us-east-1:123456789012:key/abc123"
  config_s3_bucket_name     = "my-org-config-snapshots"

  # Alternate security contact (CIS requirement)
  security_contact_name  = "Security Team"
  security_contact_email = "security@example.com"
  security_contact_phone = "+15555550100"

  tags = {
    environment = "prod"
    owner       = "security-team"
    project     = "infrastructure-hardening"
    cost_center = "1234"
  }
}
```

## Security Best Practices Enforced

| Control | What it does |
|---|---|
| IMDSv2 | `http_tokens = "required"` mitigates SSRF attacks targeting the EC2 metadata service |
| Hop Limit 1 | Prevents metadata service access from containers running on the host |
| Default SG | Default security groups are auto-created and often over-permissive; hardening them closes that gap |
| S3 Public Block | Account-level block is the final layer of defense against accidental public bucket exposure |
| EBS Encryption | All new volumes encrypted by default; no need to remember per-volume settings |
| GuardDuty | Continuous threat detection; detects EC2 compromise, crypto-mining, credential exfiltration, and more |
| CloudTrail | Immutable multi-region audit trail; log file validation detects tampering |
| Security Hub | Single pane of glass for all security findings; CIS and FSBP standards enforce a benchmark baseline |
| AWS Config | Continuous resource configuration recording; enables drift detection and compliance evaluation |
| Access Analyzer | Identifies resources shared with external entities (cross-account or public) |
| Security Contact | Ensures AWS can reach your security team for account-level security events |

## Inputs

| Name | Description | Type | Default | Required |
|---|---|---|---|---|
| `vpc_id` | VPC whose default security group will be hardened | `string` | `null` | No |
| `enable_s3_account_public_block` | Enable account-wide S3 public access block | `bool` | `true` | No |
| `enable_ec2_metadata_defaults` | Enforce IMDSv2 as account default | `bool` | `true` | No |
| `ec2_metadata_hop_limit` | IMDS hop limit (1 blocks container access) | `number` | `1` | No |
| `enable_ebs_encryption_by_default` | Enforce EBS encryption for all new volumes | `bool` | `true` | No |
| `ebs_kms_key_arn` | KMS key ARN for EBS; uses AWS-managed key if null | `string` | `null` | No |
| `enable_iam_password_policy` | Enforce strong IAM user password policy | `bool` | `true` | No |
| `password_policy_min_length` | Minimum IAM password length | `number` | `14` | No |
| `enable_access_analyzer` | Enable IAM Access Analyzer | `bool` | `true` | No |
| `enable_guardduty` | Enable Amazon GuardDuty | `bool` | `true` | No |
| `enable_guardduty_kubernetes` | Enable GuardDuty Kubernetes audit log monitoring | `bool` | `true` | No |
| `enable_cloudtrail` | Create a multi-region CloudTrail trail | `bool` | `true` | No |
| `cloudtrail_s3_bucket_name` | S3 bucket for CloudTrail logs (required if `enable_cloudtrail = true`) | `string` | `null` | Conditional |
| `cloudtrail_kms_key_arn` | KMS key ARN to encrypt CloudTrail logs | `string` | `null` | No |
| `cloudtrail_log_retention_days` | CloudWatch log group retention for CloudTrail | `number` | `365` | No |
| `enable_security_hub` | Enable AWS Security Hub | `bool` | `true` | No |
| `enable_securityhub_cis` | Subscribe to CIS AWS Foundations Benchmark standard | `bool` | `true` | No |
| `enable_securityhub_fsbp` | Subscribe to AWS Foundational Security Best Practices standard | `bool` | `true` | No |
| `enable_config` | Enable AWS Config recording | `bool` | `true` | No |
| `config_s3_bucket_name` | S3 bucket for Config snapshots (required if `enable_config = true`) | `string` | `null` | Conditional |
| `security_contact_email` | Email for alternate security contact | `string` | `null` | No |
| `security_contact_name` | Name for alternate security contact | `string` | `null` | No |
| `security_contact_phone` | Phone for alternate security contact | `string` | `null` | No |
| `security_contact_title` | Title for alternate security contact | `string` | `"Security Team"` | No |
| `tags` | Required tags: environment, owner, project, cost_center | `map(string)` | — | Yes |

## Outputs

| Name | Description |
|---|---|
| `s3_account_public_block_enabled` | Whether the S3 public access block is enabled |
| `default_security_group_id` | ID of the hardened default security group |
| `ec2_metadata_defaults_enabled` | Whether IMDSv2 defaults are enforced |
| `guardduty_detector_id` | GuardDuty detector ID |
| `guardduty_detector_arn` | GuardDuty detector ARN |
| `cloudtrail_arn` | CloudTrail trail ARN |
| `cloudtrail_log_group_name` | CloudWatch log group name for CloudTrail |
| `securityhub_enabled` | Whether Security Hub is enabled |
| `config_recorder_name` | AWS Config recorder name |
| `access_analyzer_arn` | IAM Access Analyzer ARN |

## Continuous Review

> ⚠️ **This module is paramount to your AWS account security posture.** It must be reviewed on a regular cadence. See `SEC-008` in `.Jules/backlog.md` for the standing review item.
>
> Review checklist:
> - Are all controls enabled and not accidentally toggled off in any environment?
> - Has AWS released new account-level security features (e.g., new GuardDuty protection plans, Security Hub standards)?
> - Are CIS Benchmark or FSBP standards updated to a newer version?
> - Is the CloudTrail S3 bucket access-logging and MFA-delete enforced?
> - Are Config rules reviewed for newly added resource types in the account?
> - Is the alternate security contact still reachable?
