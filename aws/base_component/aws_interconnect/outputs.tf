output "gateway_id" {
  description = "The ID of the Direct Connect Gateway"
  value       = aws_dx_gateway.this.id
}

output "connection_id" {
  description = "The ID of the Direct Connect connection"
  value       = aws_dx_connection.this.id
}

output "connection_arn" {
  description = "The ARN of the Direct Connect connection"
  value       = aws_dx_connection.this.arn
}

output "vif_id" {
  description = "The ID of the virtual interface"
  value       = var.vif_type == "PRIVATE" ? try(aws_dx_private_virtual_interface.this[0].id, null) : try(aws_dx_transit_virtual_interface.this[0].id, null)
}

output "vif_arn" {
  description = "The ARN of the virtual interface"
  value       = var.vif_type == "PRIVATE" ? try(aws_dx_private_virtual_interface.this[0].arn, null) : try(aws_dx_transit_virtual_interface.this[0].arn, null)
}

output "tags" {
  description = "A map of tags assigned to the connection"
  value       = aws_dx_connection.this.tags
}
