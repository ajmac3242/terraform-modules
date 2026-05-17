output "endpoints" {
  description = "A map of endpoint IDs"
  value       = { for k, v in aws_vpc_endpoint.this : k => v.id }
}

output "endpoint_arns" {
  description = "A map of endpoint ARNs"
  value       = { for k, v in aws_vpc_endpoint.this : k => v.arn }
}

output "tags" {
  description = "A map of tags assigned to the resources"
  value       = var.tags
}
