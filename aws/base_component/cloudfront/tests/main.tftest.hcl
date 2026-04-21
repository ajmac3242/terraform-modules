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
}
