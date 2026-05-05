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

output "tags" {
  description = "A map of tags assigned to the connection"
  value       = aws_dx_connection.this.tags
}
