# Main ACM Certificate resource
resource "aws_acm_certificate" "this" {
  region                    = var.region
  domain_name               = var.domain_name
  validation_method         = var.validation_method
  subject_alternative_names = var.subject_alternative_names

  lifecycle {
    create_before_destroy = true
  }

  tags = var.tags
}
