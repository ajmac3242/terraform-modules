# Opinionated Aurora MySQL Module with Kiro Powers (MCP) Integration

## Purpose

This module provisions an opinionated, production-grade Amazon Aurora MySQL Serverless v2 cluster with native support for Kiro Powers (MCP) integration. It standardizes database scaling, mandatory CMK encryption at rest, private VPC subnet placement, point-in-time recovery (PITR), I/O-Optimized storage (`aurora-iopt1`), and dedicated control plane and data plane IAM roles for AI-assisted database workflows.

## Usage

```hcl
module "aurora_mysql" {
  source = "../../base_component/aurora_mysql"

  cluster_identifier = "ai-app-db"
  master_username    = "dbadmin"
  master_password    = "SuperSecretPassword123!"

  vpc_id             = "vpc-0123456789abcdef0"
  vpc_cidr_block     = "10.0.0.0/16"
  private_subnet_ids = [
    "subnet-0123456789abcdef0",
    "subnet-0123456789abcdef1"
  ]

  kms_key_arn = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"

  enable_serverlessv2 = true
  serverlessv2_scaling_configuration = {
    min_capacity = 0.5
    max_capacity = 16.0
  }

  enable_kiro_mcp_integration = true

  tags = {
    environment = "production"
    owner       = "platform-team"
    project     = "kiro-ai"
    cost_center = "cc-1234"
  }
}
```

## Security

- **Encryption at Rest:** Mandatory CMK storage encryption (`kms_key_arn`) and CloudWatch log groups encryption.
- **VPC Isolation:** Placed exclusively in private subnets with restricted security group ingress from VPC CIDR only.
- **IAM Database Authentication:** IAM DB auth enabled by default (`iam_database_authentication_enabled = true`).
- **Kiro Powers (MCP) Integration:** Dedicated, least-privilege IAM control plane role for operational monitoring and data plane role for database authentication.
- **Audit Logging:** Audit, error, general, and slowquery logs exported to CMK-encrypted CloudWatch log groups.
- **Mandatory Tagging:** Enforces organizational tagging standards (`environment`, `owner`, `project`, `cost_center`).

## Variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `cluster_identifier` | Cluster identifier for the Aurora MySQL cluster | `string` | n/a | yes |
| `engine_version` | Engine version for Aurora MySQL (8.0.mysql_aurora.3.x) | `string` | `"8.0.mysql_aurora.3.05.2"` | no |
| `db_cluster_parameter_group_family` | DB cluster parameter group family | `string` | `"aurora-mysql8.0"` | no |
| `database_name` | Primary database name created on launch | `string` | `"main"` | no |
| `master_username` | Master username for DB cluster | `string` | n/a | yes |
| `master_password` | Master password for DB cluster | `string` | n/a | yes |
| `instance_class` | DB cluster instance class | `string` | `"db.serverless"` | no |
| `instances_count` | Number of DB cluster instances | `number` | `2` | no |
| `vpc_id` | VPC ID where cluster is deployed | `string` | n/a | yes |
| `vpc_cidr_block` | VPC CIDR block allowed to connect to MySQL | `string` | n/a | yes |
| `private_subnet_ids` | List of private subnet IDs for DB subnet group | `list(string)` | n/a | yes |
| `kms_key_arn` | ARN of KMS CMK for storage encryption | `string` | n/a | yes |
| `cloudwatch_kms_key_arn` | Optional ARN of KMS CMK for CloudWatch logs | `string` | `null` | no |
| `backup_retention_period` | Backup retention period in days (minimum 7) | `number` | `7` | no |
| `storage_type` | Storage type for DB cluster (`aurora-iopt1`) | `string` | `"aurora-iopt1"` | no |
| `enable_serverlessv2` | Enable Serverless v2 scaling configuration | `bool` | `true` | no |
| `serverlessv2_scaling_configuration` | Min and max capacity in ACUs | `object` | `{ min_capacity = 0.5, max_capacity = 16.0 }` | no |
| `enabled_cloudwatch_logs_exports` | Log types to export to CloudWatch Logs | `list(string)` | `["audit", "error", "general", "slowquery"]` | no |
| `log_retention_in_days` | Number of days to retain CloudWatch logs | `number` | `30` | no |
| `enable_kiro_mcp_integration` | Enable IAM roles for Kiro MCP integration | `bool` | `true` | no |
| `kiro_mcp_principal_arns` | Additional principal ARNs allowed to assume Kiro roles | `list(string)` | `[]` | no |
| `tags` | Map of tags for resource assignment | `map(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| `cluster_arn` | Amazon Resource Name (ARN) for the DB cluster |
| `cluster_identifier` | DB cluster identifier |
| `cluster_endpoint` | Primary writer DB cluster endpoint |
| `cluster_reader_endpoint` | Reader DB cluster endpoint |
| `security_group_id` | ID of the security group created for the cluster |
| `db_subnet_group_name` | Name of the DB subnet group created for the cluster |
| `kiro_mcp_control_plane_role_arn` | ARN of IAM role for Kiro Powers control plane operations |
| `kiro_mcp_data_plane_role_arn` | ARN of IAM role for Kiro Powers data plane database authentication |
| `tags` | Map of tags assigned to the DB cluster |
