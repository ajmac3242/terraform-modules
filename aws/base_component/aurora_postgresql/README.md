# aws/base_component/aurora_postgresql

## Purpose
Opinionated Aurora PostgreSQL module with Vector Search and S3 integration. This module standardizes the deployment of Aurora PostgreSQL clusters with mandatory CMK encryption, VPC placement, and optional S3 integration for data import.

## Usage
```hcl
module "aurora_postgresql" {
  source = "./aws/base_component/aurora_postgresql"

  cluster_identifier = "my-vector-db"
  instance_class     = "db.r6g.large"
  instances_count    = 2
  vpc_id             = "vpc-12345678"
  vpc_cidr_block     = "10.0.0.0/16"
  private_subnet_ids = ["subnet-11111111", "subnet-22222222"]
  kms_key_arn        = "arn:aws:kms:us-east-1:123456789012:key/xxxx-xxxx-xxxx"
  master_username    = "dbadmin"
  master_password    = "SecurePassword123!" # Use Secrets Manager in production

  s3_import_bucket_arn = "arn:aws:s3:::my-import-bucket"

  tags = {
    environment = "prod"
    owner       = "platform-team"
    project     = "vector-search"
    cost_center = "12345"
  }
}
```

## Security
- **CMK Encryption**: Mandatory storage encryption using Customer Managed Keys (CMK).
- **VPC Placement**: Cluster and instances are placed in private subnets.
- **Security Group**: Ingress is restricted to the VPC CIDR on port 5432 by default.
- **IAM Authentication**: IAM database authentication is enabled by default.
- **S3 Integration**: Least-privilege IAM role created for S3 import if a bucket ARN is provided.

## Variables
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `cluster_identifier` | The cluster identifier | `string` | n/a | yes |
| `engine_version` | The engine version for Aurora PostgreSQL | `string` | `"16.1"` | no |
| `instance_class` | The instance class for Aurora cluster instances | `string` | n/a | yes |
| `instances_count` | Number of Aurora instances | `number` | `2` | no |
| `db_cluster_parameter_group_family` | The family of the DB cluster parameter group | `string` | `"aurora-postgresql16"` | no |
| `allowed_extensions` | Comma-separated list of allowed extensions for the DB cluster. | `string` | `"pgvector,aws_lambda,aws_s3"` | no |
| `vpc_id` | VPC ID where the cluster will be deployed | `string` | n/a | yes |
| `vpc_cidr_block` | The CIDR block of the VPC | `string` | n/a | yes |
| `private_subnet_ids` | List of private subnet IDs for the DB subnet group | `list(string)` | n/a | yes |
| `kms_key_arn` | ARN of the KMS CMK for storage encryption | `string` | n/a | yes |
| `database_name` | Name for the primary database | `string` | `"postgres"` | no |
| `master_username` | Username for the master DB user | `string` | n/a | yes |
| `master_password` | Password for the master DB user | `string` | n/a | yes |
| `s3_import_bucket_arn` | Optional ARN of the S3 bucket to allow Aurora to import data from | `string` | `null` | no |
| `lambda_invocation_arns` | Optional list of Lambda function ARNs that Aurora is allowed to invoke | `list(string)` | `[]` | no |
| `backup_retention_period` | The days to retain backups for | `number` | `7` | no |
| `storage_type` | The storage type for the DB cluster. Use 'aurora-iopt1' for I/O-Optimized. | `string` | `"aurora-iopt1"` | no |
| `tags` | Standard tags for all resources | `map(string)` | n/a | yes |

## Outputs
| Name | Description |
|------|-------------|
| `cluster_arn` | The Amazon Resource Name (ARN) for the DB cluster |
| `cluster_identifier` | The cluster identifier |
| `cluster_endpoint` | The cluster endpoint |
| `cluster_reader_endpoint` | The cluster reader endpoint |
| `security_group_id` | The ID of the security group created for the cluster |
| `rds_s3_role_arn` | The ARN of the IAM role for S3 integration |
| `rds_lambda_role_arn` | The ARN of the IAM role for Lambda integration |
| `tags` | A map of tags assigned to the resource |

<!-- BEGIN_TF_DOCS -->


## Usage

```hcl
# See README.md for usage example
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_identifier"></a> [cluster\_identifier](#input\_cluster\_identifier) | The cluster identifier | `string` | n/a | yes |
| <a name="input_instance_class"></a> [instance\_class](#input\_instance\_class) | The instance class for Aurora cluster instances | `string` | n/a | yes |
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | ARN of the KMS CMK for storage encryption | `string` | n/a | yes |
| <a name="input_master_password"></a> [master\_password](#input\_master\_password) | Password for the master DB user | `string` | n/a | yes |
| <a name="input_master_username"></a> [master\_username](#input\_master\_username) | Username for the master DB user | `string` | n/a | yes |
| <a name="input_private_subnet_ids"></a> [private\_subnet\_ids](#input\_private\_subnet\_ids) | List of private subnet IDs for the DB subnet group | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to the resources | `map(string)` | n/a | yes |
| <a name="input_vpc_cidr_block"></a> [vpc\_cidr\_block](#input\_vpc\_cidr\_block) | The CIDR block of the VPC | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID where the cluster will be deployed | `string` | n/a | yes |
| <a name="input_allowed_extensions"></a> [allowed\_extensions](#input\_allowed\_extensions) | Comma-separated list of allowed extensions for the DB cluster. | `string` | `"pgvector,aws_lambda,aws_s3"` | no |
| <a name="input_backup_retention_period"></a> [backup\_retention\_period](#input\_backup\_retention\_period) | The days to retain backups for | `number` | `7` | no |
| <a name="input_database_name"></a> [database\_name](#input\_database\_name) | Name for the primary database | `string` | `"postgres"` | no |
| <a name="input_db_cluster_parameter_group_family"></a> [db\_cluster\_parameter\_group\_family](#input\_db\_cluster\_parameter\_group\_family) | The family of the DB cluster parameter group | `string` | `"aurora-postgresql16"` | no |
| <a name="input_engine_version"></a> [engine\_version](#input\_engine\_version) | The engine version for Aurora PostgreSQL | `string` | `"16.1"` | no |
| <a name="input_instances_count"></a> [instances\_count](#input\_instances\_count) | Number of Aurora instances | `number` | `2` | no |
| <a name="input_lambda_invocation_arns"></a> [lambda\_invocation\_arns](#input\_lambda\_invocation\_arns) | Optional list of Lambda function ARNs that Aurora is allowed to invoke | `list(string)` | `[]` | no |
| <a name="input_s3_import_bucket_arn"></a> [s3\_import\_bucket\_arn](#input\_s3\_import\_bucket\_arn) | Optional ARN of the S3 bucket to allow Aurora to import data from | `string` | `null` | no |
| <a name="input_storage_type"></a> [storage\_type](#input\_storage\_type) | The storage type for the DB cluster. Use 'aurora-iopt1' for I/O-Optimized. | `string` | `"aurora-iopt1"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_arn"></a> [cluster\_arn](#output\_cluster\_arn) | The Amazon Resource Name (ARN) for the DB cluster |
| <a name="output_cluster_endpoint"></a> [cluster\_endpoint](#output\_cluster\_endpoint) | The cluster endpoint |
| <a name="output_cluster_identifier"></a> [cluster\_identifier](#output\_cluster\_identifier) | The cluster identifier |
| <a name="output_cluster_reader_endpoint"></a> [cluster\_reader\_endpoint](#output\_cluster\_reader\_endpoint) | The cluster reader endpoint |
| <a name="output_rds_lambda_role_arn"></a> [rds\_lambda\_role\_arn](#output\_rds\_lambda\_role\_arn) | The ARN of the IAM role for Lambda integration |
| <a name="output_rds_s3_role_arn"></a> [rds\_s3\_role\_arn](#output\_rds\_s3\_role\_arn) | The ARN of the IAM role for S3 integration |
| <a name="output_security_group_id"></a> [security\_group\_id](#output\_security\_group\_id) | The ID of the security group created for the cluster |
| <a name="output_tags"></a> [tags](#output\_tags) | A map of tags assigned to the resource |

<!-- END_TF_DOCS -->