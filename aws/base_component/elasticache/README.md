# aws/base_component/elasticache

## Purpose
Opinionated ElastiCache module. Managed Redis with enforced CMK encryption, transit encryption, and private networking.

## Usage
```hcl
module "elasticache" {
  source = "./aws/base_component/elasticache"

  cluster_id         = "my-redis"
  subnet_ids         = module.vpc.private_subnet_ids
  kms_key_arn        = module.kms.key_arn
  security_group_ids = [module.security_group.id]

  tags = {
    environment = "prod"
    owner       = "platform-team"
    project     = "standardization"
    cost_center = "12345"
  }
}
```

## Security
- **Encryption**: Mandatory at-rest encryption using a Customer Managed Key (CMK) and mandatory transit encryption (TLS).
- **Network**: Placed in private VPC subnets via a subnet group.
- **Access**: Auth token (password) is supported and recommended.

## Variables
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `cluster_id` | Identifier for the ElastiCache cluster | `string` | n/a | yes |
| `engine` | The name of the cache engine to be used (redis or valkey) | `string` | `redis` | no |
| `engine_version` | The version number of the cache engine | `string` | `7.0` | no |
| `node_type` | Instance class to use | `string` | `cache.t3.micro` | no |
| `num_cache_nodes` | Initial number of cache nodes | `number` | `1` | no |
| `subnet_ids` | List of subnet IDs for the ElastiCache subnet group | `list(string)` | n/a | yes |
| `security_group_ids` | List of security group IDs to associate with | `list(string)` | n/a | yes |
| `kms_key_arn` | ARN for the KMS key to use for encryption at rest | `string` | n/a | yes |
| `tags` | Standard tags for all resources | `map(string)` | n/a | yes |

## Outputs
| Name | Description |
|------|-------------|
| `cluster_arn` | The ARN of the ElastiCache replication group |
| `primary_endpoint_address` | The address of the primary endpoint |
| `tags` | A map of tags assigned to the resource |
