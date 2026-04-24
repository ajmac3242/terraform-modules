variables {
  name  = "test-waf"
  scope = "REGIONAL"
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

run "valid_wafv2_creation" {
  command = plan

  assert {
    condition     = aws_wafv2_web_acl.this.name == var.name
    error_message = "WAF name does not match expected value"
  }
}
