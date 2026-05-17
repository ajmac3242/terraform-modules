output "record_fqdns" {
  description = "A list of FQDNs for the created records"
  value       = [for r in aws_route53_record.this : r.fqdn]
}

output "record_ids" {
  description = "A list of IDs for the created records"
  value       = [for r in aws_route53_record.this : r.id]
}

output "tags" {
  description = "A map of tags assigned to the resources (returns var.tags as Route 53 records do not support tags)"
  value       = var.tags
}
