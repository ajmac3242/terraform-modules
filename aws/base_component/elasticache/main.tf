# Subnet group for VPC placement
resource "aws_elasticache_subnet_group" "this" {
  name       = "${var.cluster_id}-subnet-group"
  subnet_ids = var.subnet_ids

  tags = var.tags
}

# ElastiCache Redis Replication Group (supports encryption and HA)
resource "aws_elasticache_replication_group" "this" {
  replication_group_id = var.cluster_id
  description          = "Replication group for ${var.cluster_id}"
  engine               = var.engine
  engine_version       = var.engine_version
  node_type            = var.node_type
  num_cache_clusters   = var.num_cache_nodes
  port                 = 6379
  subnet_group_name    = aws_elasticache_subnet_group.this.name
  security_group_ids   = var.security_group_ids

  # Mandatory encryption settings
  at_rest_encryption_enabled = true
  transit_encryption_enabled = true
  kms_key_id                 = var.kms_key_arn

  tags = var.tags
}
