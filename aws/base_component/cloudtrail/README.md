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

<!-- BEGIN_TF_DOCS -->


## Usage

```hcl
# See README.md for usage example
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | The ARN of the KMS key for encryption of trail logs | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | The name of the trail | `string` | n/a | yes |
| <a name="input_s3_bucket_name"></a> [s3\_bucket\_name](#input\_s3\_bucket\_name) | The name of the S3 bucket to store logs | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to the resources | `map(string)` | n/a | yes |
| <a name="input_cloudwatch_logs_group_arn"></a> [cloudwatch\_logs\_group\_arn](#input\_cloudwatch\_logs\_group\_arn) | The ARN of the CloudWatch Log Group to which CloudTrail logs will be delivered | `string` | `null` | no |
| <a name="input_cloudwatch_logs_role_arn"></a> [cloudwatch\_logs\_role\_arn](#input\_cloudwatch\_logs\_role\_arn) | The ARN of the IAM role that CloudTrail uses to send logs to CloudWatch Logs | `string` | `null` | no |
| <a name="input_enable_log_file_validation"></a> [enable\_log\_file\_validation](#input\_enable\_log\_file\_validation) | Whether log file integrity validation is enabled | `bool` | `true` | no |
| <a name="input_include_global_service_events"></a> [include\_global\_service\_events](#input\_include\_global\_service\_events) | Whether the trail is publishing events from global services | `bool` | `true` | no |
| <a name="input_is_multi_region_trail"></a> [is\_multi\_region\_trail](#input\_is\_multi\_region\_trail) | Whether the trail is created in all regions or just in one region | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_tags"></a> [tags](#output\_tags) | A map of tags assigned to the resource |
| <a name="output_trail_arn"></a> [trail\_arn](#output\_trail\_arn) | The ARN of the trail |
| <a name="output_trail_home_region"></a> [trail\_home\_region](#output\_trail\_home\_region) | The region in which the trail was created |
| <a name="output_trail_id"></a> [trail\_id](#output\_trail\_id) | The ID of the trail |

<!-- END_TF_DOCS -->