# Main CloudFront Distribution resource
resource "aws_cloudfront_distribution" "this" {
  origin {
    domain_name = var.origin_domain_name
    origin_id   = var.origin_id

    # Conditional S3 origin config
    dynamic "s3_origin_config" {
      for_each = var.origin_type == "S3" ? [1] : []
      content {
        origin_access_identity = ""
      }
    }

    # Conditional Custom origin config (ALB)
    dynamic "custom_origin_config" {
      for_each = var.origin_type == "ALB" ? [1] : []
      content {
        http_port              = 80
        https_port             = 443
        origin_protocol_policy = "https-only"
        origin_ssl_protocols   = ["TLSv1.2"]
      }
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Opinionated distribution"
  default_root_object = "index.html"

  # Enforce logging to S3
  logging_config {
    include_cookies = false
    bucket          = var.log_bucket_domain_name
    prefix          = "cloudfront/"
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = var.origin_id

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = var.tags

  # Enforce TLS 1.2 minimum
  viewer_certificate {
    cloudfront_default_certificate = true
    minimum_protocol_version       = "TLSv1.2_2021"
  }

  # Mandatory WAF association
  web_acl_id = var.waf_web_acl_id

  # Conditional cache tag config
  dynamic "cache_tag_config" {
    for_each = var.cache_tag_config_header_name != null ? [1] : []
    content {
      header_name = var.cache_tag_config_header_name
    }
  }
}
