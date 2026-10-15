output "cluster_arn" {
  description = "The Amazon Resource Name (ARN) for the Aurora MySQL DB cluster"
  value       = aws_rds_cluster.this.arn
}

output "cluster_identifier" {
  description = "The cluster identifier"
  value       = aws_rds_cluster.this.cluster_identifier
}

output "cluster_endpoint" {
  description = "The cluster writer endpoint"
  value       = aws_rds_cluster.this.endpoint
}

output "cluster_reader_endpoint" {
  description = "The cluster reader endpoint"
  value       = aws_rds_cluster.this.reader_endpoint
}

output "security_group_id" {
  description = "The ID of the security group created for the cluster"
  value       = aws_security_group.this.id
}

output "db_subnet_group_name" {
  description = "The name of the DB subnet group created for the cluster"
  value       = aws_db_subnet_group.this.name
}

output "kiro_mcp_control_plane_role_arn" {
  description = "The ARN of the IAM role for Kiro Powers (MCP) control plane operations"
  value       = var.enable_kiro_mcp_integration ? module.kiro_mcp_control_plane_role[0].role_arn : null
}

output "kiro_mcp_data_plane_role_arn" {
  description = "The ARN of the IAM role for Kiro Powers (MCP) data plane database authentication"
  value       = var.enable_kiro_mcp_integration ? module.kiro_mcp_data_plane_role[0].role_arn : null
}

output "tags" {
  description = "A map of tags assigned to the DB cluster resource"
  value       = aws_rds_cluster.this.tags_all
}
