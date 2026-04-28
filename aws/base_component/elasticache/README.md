# aws/base_component/elasticache

## Purpose
Opinionated ElastiCache module. Managed Redis with enforced CMK encryption, transit encryption, and private networking.

## Usage
```hcl
module "elasticache" {
  source = "./aws/base_component/elasticache"

  name               = "my-redis"
  subnet_ids         = module.vpc.private_subnet_ids
  kms_key_id         = module.kms.key_arn
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
| `name` | Name of the ElastiCache cluster | `string` | n/a | yes |
| `subnet_ids` | List of subnet IDs for the ElastiCache subnet group | `list(string)` | n/a | yes |
| `kms_key_id` | ARN for the KMS key to use for encryption at rest | `string` | n/a | yes |
| `security_group_ids` | List of security group IDs to associate with | `list(string)` | n/a | yes |
| `node_type` | Instance class to use | `string` | `"cache.t3.medium"` | no |
| `num_cache_nodes` | Number of cache nodes in the cluster | `number` | `1` | no |
| `tags` | Standard tags for all resources | `map(string)` | n/a | yes |

## Outputs
| Name | Description |
|------|-------------|
| `cluster_arn` | The ARN of the ElastiCache cluster |
| `primary_endpoint_address` | The address of the primary endpoint |
| `member_clusters` | The list of member clusters |
