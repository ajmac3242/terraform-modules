output "cluster_arn" {
  description = "The Amazon Resource Name (ARN) for the DB cluster"
  value       = aws_rds_cluster.this.arn
}

output "cluster_identifier" {
  description = "The cluster identifier"
  value       = aws_rds_cluster.this.cluster_identifier
}

output "cluster_endpoint" {
  description = "The cluster endpoint"
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

output "rds_s3_role_arn" {
  description = "The ARN of the IAM role for S3 integration"
  value       = length(module.rds_s3_role) > 0 ? module.rds_s3_role[0].role_arn : null
}

output "tags" {
  description = "A map of tags assigned to the resource"
  value       = aws_rds_cluster.this.tags_all
}
