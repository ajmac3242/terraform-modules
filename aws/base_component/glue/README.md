# Glue Base Module

## Purpose
This module provisions opinionated AWS Glue components, including a catalog database, security configuration (enforcing CMK encryption), crawlers, and jobs with VPC placement support.

## Usage
```hcl
module "glue" {
  source = "./aws/base_component/glue"

  name        = "my-data-pipeline"
  role_arn    = "arn:aws:iam::123456789012:role/glue-service-role"
  kms_key_arn = "arn:aws:kms:us-east-1:123456789012:key/mrk-1234"

  s3_targets = [
    { path = "s3://my-bucket/raw-data/" }
  ]

  command_script_location = "s3://my-bucket/scripts/etl_job.py"

  vpc_config = {
    subnet_ids         = ["subnet-12345"]
    security_group_ids = ["sg-12345"]
  }

  tags = {
    environment = "prod"
    owner       = "data-team"
    project     = "data-lake"
    cost_center = "5678"
  }
}
```

## Security
- **CMK Encryption**: Mandatory CMK encryption for CloudWatch logs, job bookmarks, and S3 data via Glue Security Configuration.
- **VPC Placement**: Supports deploying Glue jobs within a VPC for secure data access.
- **Least Privilege**: Designed to work with a dedicated Glue service role.

## Variables
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | The name of the Glue components | `string` | n/a | yes |
| kms_key_arn | The ARN of the KMS CMK to use for Glue encryption | `string` | n/a | yes |
| role_arn | The ARN of the IAM role for Glue Crawler and Job | `string` | n/a | yes |
| vpc_config | VPC configuration for Glue jobs | `object` | `null` | no |
| s3_targets | S3 targets for the Glue crawler | `list(object)` | `[]` | no |
| command_script_location | The S3 path to the Glue job script | `string` | `null` | no |
| tags | A map of tags to assign to the resources | `map(string)` | n/a | yes |

## Outputs
| Name | Description |
|------|-------------|
| database_name | The name of the Glue catalog database |
| database_arn | The ARN of the Glue catalog database |
| security_configuration_name | The name of the Glue security configuration |
| crawler_name | The name of the Glue crawler |
| crawler_arn | The ARN of the Glue crawler |
| job_name | The name of the Glue job |
| job_arn | The ARN of the Glue job |
| tags | The tags assigned to the resources |

<!-- BEGIN_TF_DOCS -->


## Usage

```hcl
# See README.md for usage example
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | The ARN of the KMS CMK to use for Glue encryption | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | The name of the Glue components (database, crawler, job) | `string` | n/a | yes |
| <a name="input_role_arn"></a> [role\_arn](#input\_role\_arn) | The ARN of the IAM role for Glue Crawler and Job | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to the resources | `map(string)` | n/a | yes |
| <a name="input_command_script_location"></a> [command\_script\_location](#input\_command\_script\_location) | The S3 path to the Glue job script | `string` | `null` | no |
| <a name="input_s3_targets"></a> [s3\_targets](#input\_s3\_targets) | S3 targets for the Glue crawler | ```list(object({ path = string }))``` | `[]` | no |
| <a name="input_vpc_config"></a> [vpc\_config](#input\_vpc\_config) | VPC configuration for Glue jobs (subnet\_ids, security\_group\_ids) | ```object({ subnet_ids = list(string) security_group_ids = list(string) })``` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_crawler_arn"></a> [crawler\_arn](#output\_crawler\_arn) | The ARN of the Glue crawler |
| <a name="output_crawler_name"></a> [crawler\_name](#output\_crawler\_name) | The name of the Glue crawler |
| <a name="output_database_arn"></a> [database\_arn](#output\_database\_arn) | The ARN of the Glue catalog database |
| <a name="output_database_name"></a> [database\_name](#output\_database\_name) | The name of the Glue catalog database |
| <a name="output_job_arn"></a> [job\_arn](#output\_job\_arn) | The ARN of the Glue job |
| <a name="output_job_name"></a> [job\_name](#output\_job\_name) | The name of the Glue job |
| <a name="output_security_configuration_name"></a> [security\_configuration\_name](#output\_security\_configuration\_name) | The name of the Glue security configuration |
| <a name="output_tags"></a> [tags](#output\_tags) | The tags assigned to the resources |

<!-- END_TF_DOCS -->