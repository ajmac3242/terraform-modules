variables {
  domain_name     = "test.example.com"
  route53_zone_id = "Z1234567890"
  waf_web_acl_arn = "arn:aws:wafv2:us-east-1:123456789012:global/webacl/test-waf/12345678-1234-1234-1234-123456789012"
  log_bucket_id   = "test-log-bucket"
  aws_account_id  = "123456789012"
  tags = {
    environment = "test"
    owner       = "test-owner"
    project     = "test-project"
    cost_center = "test-cc"
  }
}

provider "aws" {
  region                      = "us-east-1"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true
  access_key                  = "mock_access_key"
  secret_key                  = "mock_secret_key"
}

run "valid_static_website_creation" {
  command = plan

  assert {
    condition     = aws_cloudfront_distribution.this.enabled == true
    error_message = "CloudFront distribution should be enabled"
  }

  assert {
    condition     = aws_cloudfront_distribution.this.viewer_certificate[0].minimum_protocol_version == "TLSv1.2_2021"
    error_message = "Minimum TLS version is incorrect"
  }

  assert {
    condition     = aws_cloudfront_distribution.this.web_acl_id == var.waf_web_acl_arn
    error_message = "WAF ARN does not match"
  }

  assert {
    condition     = aws_cloudfront_distribution.this.tags["environment"] == "test" && aws_cloudfront_distribution.this.tags["owner"] == "test-owner" && aws_cloudfront_distribution.this.tags["project"] == "test-project" && aws_cloudfront_distribution.this.tags["cost_center"] == "test-cc"
    error_message = "Mandatory tags are missing or incorrect on CloudFront distribution"
  }
}
