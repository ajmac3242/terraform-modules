# CloudTrail Module

## Purpose
Standardizes organizational governance, audit logging, and compliance monitoring by creating opinionated CloudTrail trails.

## Usage
```hcl
module "cloudtrail" {
  source = "./aws/base_component/cloudtrail"

  name           = "org-audit-trail"
  s3_bucket_name = "my-audit-logs-bucket"
  kms_key_arn    = "arn:aws:kms:us-east-1:123456789012:key/..."

  tags = {
    environment = "prod"
    owner       = "security-team"
    project     = "governance"
    cost_center = "1234"
  }
}
```

## Security
- Mandatory CMK encryption for trail logs.
- Multi-region trail enabled by default.
- Global service events enabled by default.
- Log file integrity validation enabled.
- CloudWatch Logs integration supported.

## Variables
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | The name of the trail | string | n/a | yes |
| s3_bucket_name | The name of the S3 bucket to store logs | string | n/a | yes |
| kms_key_arn | ARN of the KMS key for encryption | string | n/a | yes |
| is_multi_region_trail | Whether the trail is multi-region | bool | true | no |
| include_global_service_events | Whether to include global events | bool | true | no |
| enable_log_file_validation | Whether to enable log integrity | bool | true | no |
| cloudwatch_logs_group_arn | ARN of the CW Log Group | string | null | no |
| cloudwatch_logs_role_arn | ARN of the IAM role for CW Logs | string | null | no |
| tags | Resource tags | map(string) | n/a | yes |

## Outputs
| Name | Description |
|------|-------------|
| trail_arn | The ARN of the trail |
| trail_id | The ID of the trail |
| trail_home_region | The region in which the trail was created |
| tags | Tags assigned to the resource |
