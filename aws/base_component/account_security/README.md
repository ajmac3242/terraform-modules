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
| `tags` | A map of tags assigned to the resources |

<!-- BEGIN_TF_DOCS -->


## Usage

```hcl
# See README.md for usage example
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to the resources. Required keys: environment, owner, project, cost\_center. | `map(string)` | n/a | yes |
| <a name="input_billing_contact_email"></a> [billing\_contact\_email](#input\_billing\_contact\_email) | Email address of the alternate billing contact. When non-null, the contact record is created. Use a team/group mailbox. | `string` | `null` | no |
| <a name="input_billing_contact_name"></a> [billing\_contact\_name](#input\_billing\_contact\_name) | Full name of the alternate billing contact for the AWS account | `string` | `null` | no |
| <a name="input_billing_contact_phone"></a> [billing\_contact\_phone](#input\_billing\_contact\_phone) | Phone number of the alternate billing contact (E.164 format recommended, e.g. +15555550100) | `string` | `null` | no |
| <a name="input_billing_contact_title"></a> [billing\_contact\_title](#input\_billing\_contact\_title) | Title or role of the alternate billing contact | `string` | `"Billing Team"` | no |
| <a name="input_create_support_role"></a> [create\_support\_role](#input\_create\_support\_role) | Whether to create the CIS-required IAM Support role | `bool` | `true` | no |
| <a name="input_ebs_kms_key_arn"></a> [ebs\_kms\_key\_arn](#input\_ebs\_kms\_key\_arn) | The ARN of the KMS key for default EBS encryption. If null, the default aws/ebs key is used. | `string` | `null` | no |
| <a name="input_ec2_metadata_hop_limit"></a> [ec2\_metadata\_hop\_limit](#input\_ec2\_metadata\_hop\_limit) | The desired HTTP PUT response hop limit for instance metadata requests. Best practice is 1 to prevent hop to containers. | `number` | `1` | no |
| <a name="input_enable_access_analyzer"></a> [enable\_access\_analyzer](#input\_enable\_access\_analyzer) | Whether to enable IAM Access Analyzer for the account | `bool` | `true` | no |
| <a name="input_enable_ebs_encryption_by_default"></a> [enable\_ebs\_encryption\_by\_default](#input\_enable\_ebs\_encryption\_by\_default) | Whether to enable account-level EBS encryption by default | `bool` | `true` | no |
| <a name="input_enable_ec2_metadata_defaults"></a> [enable\_ec2\_metadata\_defaults](#input\_enable\_ec2\_metadata\_defaults) | Whether to enable account-level EC2 instance metadata defaults (IMDSv2 enforcement) | `bool` | `true` | no |
| <a name="input_enable_guardduty"></a> [enable\_guardduty](#input\_enable\_guardduty) | Whether to enable Amazon GuardDuty for the account/region | `bool` | `true` | no |
| <a name="input_enable_guardduty_kubernetes"></a> [enable\_guardduty\_kubernetes](#input\_enable\_guardduty\_kubernetes) | Whether to enable GuardDuty Kubernetes Audit Log monitoring. Set to false in accounts where EKS is not used. | `bool` | `true` | no |
| <a name="input_enable_iam_password_policy"></a> [enable\_iam\_password\_policy](#input\_enable\_iam\_password\_policy) | Whether to enable the account-level IAM password policy | `bool` | `true` | no |
| <a name="input_enable_s3_account_public_block"></a> [enable\_s3\_account\_public\_block](#input\_enable\_s3\_account\_public\_block) | Whether to enable the account-level S3 Public Access Block | `bool` | `true` | no |
| <a name="input_enable_serial_console_access"></a> [enable\_serial\_console\_access](#input\_enable\_serial\_console\_access) | Whether to enable EC2 serial console access. CIS recommends false. | `bool` | `false` | no |
| <a name="input_operations_contact_email"></a> [operations\_contact\_email](#input\_operations\_contact\_email) | Email address of the alternate operations contact. When non-null, the contact record is created. Use a team/group mailbox. | `string` | `null` | no |
| <a name="input_operations_contact_name"></a> [operations\_contact\_name](#input\_operations\_contact\_name) | Full name of the alternate operations contact for the AWS account | `string` | `null` | no |
| <a name="input_operations_contact_phone"></a> [operations\_contact\_phone](#input\_operations\_contact\_phone) | Phone number of the alternate operations contact (E.164 format recommended, e.g. +15555550100) | `string` | `null` | no |
| <a name="input_operations_contact_title"></a> [operations\_contact\_title](#input\_operations\_contact\_title) | Title or role of the alternate operations contact | `string` | `"Operations Team"` | no |
| <a name="input_password_policy_min_length"></a> [password\_policy\_min\_length](#input\_password\_policy\_min\_length) | Minimum length to require for IAM user passwords. AWS minimum is 6; CIS recommends 14+. | `number` | `14` | no |
| <a name="input_security_contact_email"></a> [security\_contact\_email](#input\_security\_contact\_email) | Email address of the alternate security contact. When non-null, the contact record is created. Use a team/group mailbox. | `string` | `null` | no |
| <a name="input_security_contact_name"></a> [security\_contact\_name](#input\_security\_contact\_name) | Full name of the alternate security contact for the AWS account | `string` | `null` | no |
| <a name="input_security_contact_phone"></a> [security\_contact\_phone](#input\_security\_contact\_phone) | Phone number of the alternate security contact (E.164 format recommended, e.g. +15555550100) | `string` | `null` | no |
| <a name="input_security_contact_title"></a> [security\_contact\_title](#input\_security\_contact\_title) | Title or role of the alternate security contact | `string` | `"Security Team"` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The ID of the VPC to harden the default security group. If null, this resource is skipped. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_access_analyzer_arn"></a> [access\_analyzer\_arn](#output\_access\_analyzer\_arn) | The ARN of the IAM Access Analyzer, or null if disabled |
| <a name="output_billing_contact_email"></a> [billing\_contact\_email](#output\_billing\_contact\_email) | The email address of the registered alternate billing contact, or null if not set |
| <a name="output_default_security_group_id"></a> [default\_security\_group\_id](#output\_default\_security\_group\_id) | The ID of the hardened default security group, or null if vpc\_id was not provided |
| <a name="output_ebs_encryption_enabled"></a> [ebs\_encryption\_enabled](#output\_ebs\_encryption\_enabled) | Whether account-level EBS encryption by default is enabled |
| <a name="output_ec2_metadata_defaults_enabled"></a> [ec2\_metadata\_defaults\_enabled](#output\_ec2\_metadata\_defaults\_enabled) | Whether the account-level EC2 metadata defaults (IMDSv2) are enabled |
| <a name="output_guardduty_detector_arn"></a> [guardduty\_detector\_arn](#output\_guardduty\_detector\_arn) | The ARN of the GuardDuty detector, or null if GuardDuty is disabled |
| <a name="output_guardduty_detector_id"></a> [guardduty\_detector\_id](#output\_guardduty\_detector\_id) | The ID of the GuardDuty detector, or null if GuardDuty is disabled |
| <a name="output_iam_password_policy_enabled"></a> [iam\_password\_policy\_enabled](#output\_iam\_password\_policy\_enabled) | Whether the account-level IAM password policy is enabled |
| <a name="output_operations_contact_email"></a> [operations\_contact\_email](#output\_operations\_contact\_email) | The email address of the registered alternate operations contact, or null if not set |
| <a name="output_s3_account_public_block_enabled"></a> [s3\_account\_public\_block\_enabled](#output\_s3\_account\_public\_block\_enabled) | Whether the account-level S3 Public Access Block is enabled |
| <a name="output_security_contact_email"></a> [security\_contact\_email](#output\_security\_contact\_email) | The email address of the registered alternate security contact, or null if not set |
| <a name="output_support_role_arn"></a> [support\_role\_arn](#output\_support\_role\_arn) | The ARN of the IAM Support role |
| <a name="output_support_role_name"></a> [support\_role\_name](#output\_support\_role\_name) | The name of the IAM Support role |
| <a name="output_tags"></a> [tags](#output\_tags) | A map of tags assigned to the resources |

<!-- END_TF_DOCS -->