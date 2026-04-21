# aws/base_component/elasticache

Opinionated ElastiCache Redis module. Enforces VPC placement, at-rest encryption (CMK), and transit encryption.

## Features

- Managed Redis cluster with configurable node types
- Mandatory at-rest encryption using CMK
- Mandatory transit encryption
- Placed in VPC private subnets via subnet group
- Required tags enforced

## Usage

```hcl
module "redis" {
  source = "./aws/base_component/elasticache"

  cluster_id         = "my-cache-prod"
  node_type          = "cache.t3.small"
  subnet_ids         = module.vpc.private_subnet_ids
  security_group_ids = [module.cache_sg.security_group_id]
  kms_key_id         = module.kms.key_arn

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
| `cluster_id` | Identifier for the cluster | `string` | n/a | yes |
| `node_type` | Instance class | `string` | `"cache.t3.micro"` | no |
| `num_cache_nodes` | Number of nodes | `number` | `1` | no |
| `subnet_ids` | VPC subnets | `list(string)` | n/a | yes |
| `security_group_ids` | Security groups | `list(string)` | n/a | yes |
| `kms_key_id` | ARN of the KMS key | `string` | n/a | yes |
| `tags` | Map of tags | `map(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| `cache_nodes` | List of node address/port |
| `cluster_arn` | The ARN of the cluster |
