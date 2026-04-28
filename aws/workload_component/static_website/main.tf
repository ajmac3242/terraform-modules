# Origin S3 Bucket for static content
module "s3_origin" {
  source = "../../base_component/s3"

  bucket_name           = "${replace(var.domain_name, ".", "-")}-origin"
  enable_access_logging = true
  log_bucket_id         = var.log_bucket_id
  aws_account_id        = var.aws_account_id

  tags = var.tags
}

# CloudFront Origin Access Control (OAC)
resource "aws_cloudfront_origin_access_control" "this" {
  name                              = "${var.domain_name}-oac"
  description                       = "OAC for ${var.domain_name} static website"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# ACM Certificate for the domain
module "acm" {
  source = "../../base_component/acm"

  domain_name               = var.domain_name
  subject_alternative_names = var.alternate_domains

  tags = var.tags
}

# CloudFront Distribution
# We can't use the base module easily because it doesn't support OAC or custom aliases yet.
# I will implement the distribution directly here to ensure it meets the workload requirements.
resource "aws_cloudfront_distribution" "this" {
  origin {
    domain_name              = module.s3_origin.bucket_regional_domain_name
    origin_id                = "S3-Origin"
    origin_access_control_id = aws_cloudfront_origin_access_control.this.id
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Static website for ${var.domain_name}"
  default_root_object = "index.html"
  aliases             = concat([var.domain_name], var.alternate_domains)

  logging_config {
    include_cookies = false
    bucket          = "${var.log_bucket_id}.s3.amazonaws.com"
    prefix          = "cloudfront/"
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-Origin"

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

  viewer_certificate {
    acm_certificate_arn      = module.acm.certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  web_acl_id = var.waf_web_acl_arn

  tags = var.tags
}

# Update S3 bucket policy to allow CloudFront OAC access
resource "aws_s3_bucket_policy" "oac" {
  bucket = module.s3_origin.bucket_id
  policy = data.aws_iam_policy_document.oac.json
}

data "aws_iam_policy_document" "oac" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${module.s3_origin.bucket_arn}/*"]

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.this.arn]
    }
  }
}

# Route 53 Records
module "route53_alias" {
  source = "../../base_component/route53"

  zone_id = var.route53_zone_id
  records = [
    {
      name = ""
      type = "A"
      alias = {
        name                   = aws_cloudfront_distribution.this.domain_name
        zone_id                = aws_cloudfront_distribution.this.hosted_zone_id
        evaluate_target_health = false
      }
    },
    {
      name = ""
      type = "AAAA"
      alias = {
        name                   = aws_cloudfront_distribution.this.domain_name
        zone_id                = aws_cloudfront_distribution.this.hosted_zone_id
        evaluate_target_health = false
      }
    }
  ]
}
