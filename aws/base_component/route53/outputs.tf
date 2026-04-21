output "record_fqdns" {
  description = "A list of FQDNs for the created records"
  value       = [for r in aws_route53_record.this : r.fqdn]
}
