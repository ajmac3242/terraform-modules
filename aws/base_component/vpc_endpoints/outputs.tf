output "endpoints" {
  description = "A map of endpoint IDs"
  value       = { for k, v in aws_vpc_endpoint.this : k => v.id }
}
