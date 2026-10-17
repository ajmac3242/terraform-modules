# Secure Glue ETL Pattern

## Purpose
This workload module composes S3, Glue, and IAM into a secure, opinionated data processing pipeline. It provisions raw, processed, and script storage, configures Glue cataloging and ETL jobs, and enforces least-privilege security and CMK encryption.

## Usage
```hcl
module "glue_etl" {
  source = "./aws/workload_component/glue_etl_pattern"

  name            = "sales-etl"
  kms_key_arn     = "arn:aws:kms:us-east-1:123456789012:key/mrk-1234"
  etl_script_path = "./etl_scripts/transform.py"

  vpc_config = {
    subnet_ids         = ["subnet-12345"]
    security_group_ids = ["sg-12345"]
  }

  tags = {
    environment = "prod"
    owner       = "finance-analytics"
    project     = "revenue-reporting"
    cost_center = "9999"
  }
}
```

## Security
- **CMK Encryption**: All S3 buckets, Glue catalog, and job logs are encrypted with the provided customer-managed key (CMK).
- **Least Privilege IAM**: The module creates a dedicated Glue role with a scoping policy restricted to the specific S3 buckets created by the module and the provided KMS key.
- **VPC Isolation**: Glue jobs are configured for VPC placement to ensure data remains within the private network.
- **Data Hygiene**: public access is blocked for all created S3 buckets by default via the base S3 module.

## Variables
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | The name prefix for the ETL pattern resources | `string` | n/a | yes |
| kms_key_arn | The ARN of the KMS CMK to use for all encryption | `string` | n/a | yes |
| vpc_config | VPC configuration for the Glue job | `object` | n/a | yes |
| etl_script_path | Local path to the ETL script to upload to S3 | `string` | n/a | yes |
| tags | A map of tags to assign to the resources | `map(string)` | n/a | yes |

## Outputs
| Name | Description |
|------|-------------|
| raw_bucket_arn | The ARN of the raw data S3 bucket |
| processed_bucket_arn | The ARN of the processed data S3 bucket |
| scripts_bucket_arn | The ARN of the scripts S3 bucket |
| glue_role_arn | The ARN of the Glue IAM role |
| glue_database_name | The name of the Glue catalog database |
| glue_database_arn | The ARN of the Glue catalog database |
| glue_crawler_name | The name of the Glue crawler |
| glue_crawler_arn | The ARN of the Glue crawler |
| glue_job_name | The name of the Glue job |
| glue_job_arn | The ARN of the Glue job |
| tags | The tags assigned to the resources |

<!-- BEGIN_TF_DOCS -->


## Usage

```hcl
# See README.md for usage example
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_etl_script_path"></a> [etl\_script\_path](#input\_etl\_script\_path) | Local path to the ETL script to upload to S3 | `string` | n/a | yes |
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | The ARN of the KMS CMK to use for all encryption | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | The name prefix for the ETL pattern resources | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to the resources | `map(string)` | n/a | yes |
| <a name="input_vpc_config"></a> [vpc\_config](#input\_vpc\_config) | VPC configuration for the Glue job | ```object({ subnet_ids = list(string) security_group_ids = list(string) })``` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_glue_crawler_arn"></a> [glue\_crawler\_arn](#output\_glue\_crawler\_arn) | The ARN of the Glue crawler |
| <a name="output_glue_crawler_name"></a> [glue\_crawler\_name](#output\_glue\_crawler\_name) | The name of the Glue crawler |
| <a name="output_glue_database_arn"></a> [glue\_database\_arn](#output\_glue\_database\_arn) | The ARN of the Glue catalog database |
| <a name="output_glue_database_name"></a> [glue\_database\_name](#output\_glue\_database\_name) | The name of the Glue catalog database |
| <a name="output_glue_job_arn"></a> [glue\_job\_arn](#output\_glue\_job\_arn) | The ARN of the Glue job |
| <a name="output_glue_job_name"></a> [glue\_job\_name](#output\_glue\_job\_name) | The name of the Glue job |
| <a name="output_glue_role_arn"></a> [glue\_role\_arn](#output\_glue\_role\_arn) | The ARN of the Glue IAM role |
| <a name="output_processed_bucket_arn"></a> [processed\_bucket\_arn](#output\_processed\_bucket\_arn) | The ARN of the processed data S3 bucket |
| <a name="output_raw_bucket_arn"></a> [raw\_bucket\_arn](#output\_raw\_bucket\_arn) | The ARN of the raw data S3 bucket |
| <a name="output_scripts_bucket_arn"></a> [scripts\_bucket\_arn](#output\_scripts\_bucket\_arn) | The ARN of the scripts S3 bucket |
| <a name="output_tags"></a> [tags](#output\_tags) | The tags assigned to the resources |

<!-- END_TF_DOCS -->