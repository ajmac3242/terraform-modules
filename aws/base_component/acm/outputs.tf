output "certificate_arn" {
  description = "The ARN of the certificate"
  value       = aws_acm_certificate.this.arn
}

output "domain_validation_options" {
  description = "Set of domain validation objects which can be used to complete certificate validation"
  value       = aws_acm_certificate.this.domain_validation_options
}
