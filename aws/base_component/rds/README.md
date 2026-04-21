# aws/base_component/rds

Opinionated RDS instance module. Enforces CMK encryption, Multi-AZ for prod, and VPC placement.

## Features

- `aws_db_instance` (Postgres/MySQL) with configurable engine, version, instance class
- Mandatory `kms_key_id` for storage encryption
- `multi_az` defaults to `true`
- `storage_encrypted` must be `true`
- Placed in VPC private subnets via `aws_db_subnet_group`
- Required tags enforced

## Usage

```hcl
module "rds" {
  source = "./aws/base_component/rds"

  identifier     = "my-db-prod"
  engine         = "postgres"
  engine_version = "15.3"
  instance_class = "db.t3.medium"
  db_name        = "myapp"
  username       = "dbadmin"
  password       = var.db_password

  subnet_ids             = module.vpc.private_subnet_ids
  vpc_security_group_ids = [module.db_sg.security_group_id]
  kms_key_id             = module.kms.key_arn

  tags = {
    environment = "prod"
    owner       = "platform-team"
    project     = "my-app"
    cost_center = "CC-1234"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `identifier` | The name of the RDS instance | `string` | n/a | yes |
| `engine` | The database engine to use | `string` | `"postgres"` | no |
| `engine_version` | The engine version to use | `string` | n/a | yes |
| `instance_class` | The instance type of the RDS instance | `string` | `"db.t3.micro"` | no |
| `allocated_storage` | The allocated storage in gibibytes | `number` | `20` | no |
| `db_name` | The name of the database to create | `string` | n/a | yes |
| `username` | Username for the master DB user | `string` | n/a | yes |
| `password` | Password for the master DB user | `string` | n/a | yes |
| `vpc_security_group_ids` | List of VPC security groups to associate | `list(string)` | n/a | yes |
| `subnet_ids` | A list of VPC subnet IDs | `list(string)` | n/a | yes |
| `multi_az` | Specifies if the RDS instance is multi-AZ | `bool` | `true` | no |
| `kms_key_id` | The ARN for the KMS encryption key | `string` | n/a | yes |
| `tags` | A map of tags to assign to the resources. Required keys: `environment`, `owner`, `project`, `cost_center`. | `map(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| `db_instance_arn` | The ARN of the RDS instance |
| `db_instance_endpoint` | The connection endpoint |
| `db_instance_id` | The RDS instance ID |
