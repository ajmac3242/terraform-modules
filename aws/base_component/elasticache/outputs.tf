output "primary_endpoint_address" {
  description = "The address of the endpoint for the primary node in the replication group"
  value       = aws_elasticache_replication_group.this.primary_endpoint_address
}

output "cluster_arn" {
  description = "The ARN of the ElastiCache replication group"
  value       = aws_elasticache_replication_group.this.arn
}

output "tags" {
  description = "A map of tags assigned to the resource"
  value       = aws_elasticache_replication_group.this.tags_all
}
