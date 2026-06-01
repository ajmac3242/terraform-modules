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
