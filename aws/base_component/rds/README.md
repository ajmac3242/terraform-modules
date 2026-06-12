# aws/base_component/rds

## Purpose
Opinionated RDS instance module. Core relational storage, enforcing CMK encryption, Multi-AZ for production, and private VPC placement.

## Usage
```hcl
module "rds" {
  source = "./aws/base_component/rds"

  identifier     = "my-db"
  engine         = "postgres"
  engine_version = "15.3"
  instance_class = "db.t3.medium"
  allocated_storage = 20

  db_name  = "myapp"
  username = "admin"

  vpc_id      = module.vpc.vpc_id
  subnet_ids  = module.vpc.private_subnet_ids
  kms_key_arn = module.kms.key_arn

  tags = {
    environment = "prod"
    owner       = "platform-team"
    project     = "standardization"
    cost_center = "12345"
  }
}
```

## Security
- **Encryption**: Mandatory storage encryption using a Customer Managed Key (CMK).
- **Availability**: `multi_az` defaults to `true` for high availability.
- **Network**: Placed in private VPC subnets via a DB subnet group. Public access is disabled.

## Variables
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `identifier` | The name of the RDS instance | `string` | n/a | yes |
| `engine` | The database engine to use | `string` | n/a | yes |
| `engine_version` | The engine version to use | `string` | n/a | yes |
| `instance_class` | The instance type of the RDS instance | `string` | n/a | yes |
| `allocated_storage` | The allocated storage in gigabytes | `number` | n/a | yes |
| `db_name` | The name of the database to create when the DB instance is created | `string` | `null` | no |
| `username` | Username for the master DB user | `string` | n/a | yes |
| `password` | Password for the master DB user. If null, a random password is generated. | `string` | `null` | no |
| `vpc_id` | VPC ID where the RDS instance will be deployed | `string` | n/a | yes |
| `subnet_ids` | List of subnet IDs for the DB subnet group | `list(string)` | n/a | yes |
| `kms_key_arn` | ARN for the KMS key to use for storage encryption | `string` | n/a | yes |
| `multi_az` | Specifies if the RDS instance is multi-AZ | `bool` | `true` | no |
| `tags` | Standard tags for all resources | `map(string)` | n/a | yes |

## Outputs
| Name | Description |
|------|-------------|
| `db_instance_arn` | The ARN of the RDS instance |
| `db_instance_endpoint` | The connection endpoint |
| `db_instance_id` | The RDS instance ID |
| `db_instance_username` | The master username |
| `tags` | A map of tags assigned to the resource |

<!-- BEGIN_TF_DOCS -->


## Usage

```hcl
# See README.md for usage example
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_db_name"></a> [db\_name](#input\_db\_name) | The name of the database to create when the DB instance is created | `string` | n/a | yes |
| <a name="input_engine_version"></a> [engine\_version](#input\_engine\_version) | The engine version to use | `string` | n/a | yes |
| <a name="input_identifier"></a> [identifier](#input\_identifier) | The name of the RDS instance | `string` | n/a | yes |
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | The ARN for the KMS encryption key | `string` | n/a | yes |
| <a name="input_password"></a> [password](#input\_password) | Password for the master DB user. Use SSM/Secrets Manager in real scenarios. | `string` | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | A list of VPC subnet IDs | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to the resources | `map(string)` | n/a | yes |
| <a name="input_username"></a> [username](#input\_username) | Username for the master DB user | `string` | n/a | yes |
| <a name="input_vpc_security_group_ids"></a> [vpc\_security\_group\_ids](#input\_vpc\_security\_group\_ids) | List of VPC security groups to associate | `list(string)` | n/a | yes |
| <a name="input_allocated_storage"></a> [allocated\_storage](#input\_allocated\_storage) | The allocated storage in gibibytes | `number` | `20` | no |
| <a name="input_engine"></a> [engine](#input\_engine) | The database engine to use | `string` | `"postgres"` | no |
| <a name="input_instance_class"></a> [instance\_class](#input\_instance\_class) | The instance type of the RDS instance | `string` | `"db.t3.micro"` | no |
| <a name="input_multi_az"></a> [multi\_az](#input\_multi\_az) | Specifies if the RDS instance is multi-AZ | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_db_instance_arn"></a> [db\_instance\_arn](#output\_db\_instance\_arn) | The ARN of the RDS instance |
| <a name="output_db_instance_endpoint"></a> [db\_instance\_endpoint](#output\_db\_instance\_endpoint) | The connection endpoint |
| <a name="output_db_instance_id"></a> [db\_instance\_id](#output\_db\_instance\_id) | The RDS instance ID |
| <a name="output_tags"></a> [tags](#output\_tags) | A map of tags assigned to the resource |

<!-- END_TF_DOCS -->