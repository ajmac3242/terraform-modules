variables {
  zone_id = "Z12345"
  records = [
    {
      name    = "test"
      type    = "A"
      ttl     = 300
      records = ["127.0.0.1"]
    }
  ]
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

run "valid_records_creation" {
  command = plan

  assert {
    condition     = length(aws_route53_record.this) == 1
    error_message = "Expected 1 Route 53 record"
  }
}
