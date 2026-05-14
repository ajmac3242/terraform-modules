# Secure Glue ETL Pattern

## Purpose
This workload module composes S3, Glue, and IAM into a secure, opinionated data processing pipeline. It provisions raw, processed, and script storage, configures Glue cataloging and ETL jobs, and enforces least-privilege security and CMK encryption.

## Usage
```hcl
module "glue_etl" {
  source = "../../workload_component/glue_etl_pattern"

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
| glue_crawler_name | The name of the Glue crawler |
| glue_job_name | The name of the Glue job |
| tags | The tags assigned to the resources |
