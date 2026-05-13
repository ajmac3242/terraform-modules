output "service_network_id" {
  description = "The ID of the VPC Lattice service network"
  value       = aws_vpclattice_service_network.this.id
}

output "service_network_arn" {
  description = "The ARN of the VPC Lattice service network"
  value       = aws_vpclattice_service_network.this.arn
}

output "service_id" {
  description = "The ID of the VPC Lattice service"
  value       = aws_vpclattice_service.this.id
}

output "service_arn" {
  description = "The ARN of the VPC Lattice service"
  value       = aws_vpclattice_service.this.arn
}

output "log_group_arn" {
  description = "The ARN of the CloudWatch Log Group for VPC Lattice access logs"
  value       = aws_cloudwatch_log_group.this.arn
}

output "tags" {
  description = "The tags assigned to the resources"
  value       = var.tags
}
