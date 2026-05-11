output "tgw_id" {
  description = "The ID of the Transit Gateway"
  value       = aws_ec2_transit_gateway.this.id
}

output "dx_gateway_id" {
  description = "The ID of the Direct Connect Gateway"
  value       = module.interconnect.gateway_id
}

output "hub_arn" {
  description = "The ARN of the Transit Gateway"
  value       = aws_ec2_transit_gateway.this.arn
}

output "interconnect_connection_id" {
  description = "The ID of the Direct Connect connection"
  value       = module.interconnect.connection_id
}

output "vif_id" {
  description = "The ID of the Transit Virtual Interface"
  value       = module.interconnect.vif_id
}

output "tgw_log_role_arn" {
  description = "The ARN of the IAM role used for Transit Gateway Flow Logs"
  value       = module.tgw_log_role.role_arn
}

output "tags" {
  description = "A map of tags assigned to the resources"
  value       = var.tags
}
