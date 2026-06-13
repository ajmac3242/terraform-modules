variables {
  origin_domain_name     = "test-bucket.s3.amazonaws.com"
  origin_id              = "S3-test"
  waf_web_acl_id         = "waf-12345"
  log_bucket_domain_name = "logs.s3.amazonaws.com"
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

run "valid_distribution_creation" {
  command = plan

  assert {
    condition     = aws_cloudfront_distribution.this.enabled == true
    error_message = "Distribution should be enabled"
  }

  assert {
    condition     = aws_cloudfront_distribution.this.viewer_certificate[0].minimum_protocol_version == "TLSv1.2_2021"
    error_message = "Minimum TLS version is incorrect"
  }

  assert {
    condition     = aws_cloudfront_distribution.this.web_acl_id == var.waf_web_acl_id
    error_message = "WAF ID does not match"
  }

  assert {
    condition     = aws_cloudfront_distribution.this.tags["environment"] == "test" && aws_cloudfront_distribution.this.tags["owner"] == "test-owner" && aws_cloudfront_distribution.this.tags["project"] == "test-project" && aws_cloudfront_distribution.this.tags["cost_center"] == "test-cc"
    error_message = "Mandatory tags are missing or incorrect on CloudFront distribution."
  }
}

run "valid_distribution_creation_with_cache_tags" {
  command = plan

  variables {
    cache_tag_config_header_name = "X-Cache-Tags"
  }

  assert {
    condition     = length(aws_cloudfront_distribution.this.cache_tag_config) > 0
    error_message = "Cache tag configuration is missing"
  }

  assert {
    condition     = aws_cloudfront_distribution.this.cache_tag_config[0].header_name == "X-Cache-Tags"
    error_message = "Cache tag header name does not match"
  }
}
