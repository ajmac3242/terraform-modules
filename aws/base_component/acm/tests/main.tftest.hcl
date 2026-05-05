variables {
  domain_name       = "example.com"
  region            = "us-east-1"
  validation_method = "DNS"
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

run "valid_acm_creation" {
  command = plan

  assert {
    condition     = aws_acm_certificate.this.domain_name == var.domain_name
    error_message = "Domain name does not match expected value"
  }

  assert {
    condition     = aws_acm_certificate.this.region == "us-east-1"
    error_message = "Region attribute was not correctly passed to the ACM resource"
  }

  assert {
    condition     = aws_acm_certificate.this.tags["environment"] == "test" && aws_acm_certificate.this.tags["owner"] == "test-owner" && aws_acm_certificate.this.tags["project"] == "test-project" && aws_acm_certificate.this.tags["cost_center"] == "test-cc"
    error_message = "Mandatory tags are missing or incorrect on ACM certificate."
  }
}
