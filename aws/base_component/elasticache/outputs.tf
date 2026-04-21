output "cache_nodes" {
  description = "List of node objects including address and port"
  value       = aws_elasticache_cluster.this.cache_nodes
}

output "cluster_arn" {
  description = "The ARN of the ElastiCache cluster"
  value       = aws_elasticache_cluster.this.arn
}
