variables {
  name           = "test-trail"
  s3_bucket_name = "test-bucket"
  kms_key_arn    = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"
  tags = {
    environment = "test"
    owner       = "builder"
    project     = "infrastructure"
    cost_center = "12345"
  }
}

provider "aws" {
  region                      = "us-east-1"
  access_key                  = "mock_access_key"
  secret_key                  = "mock_secret_key"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
}

run "validate_cloudtrail_creation" {
  command = plan

  assert {
    condition     = aws_cloudtrail.this.name == var.name
    error_message = "Trail name does not match input"
  }

  assert {
    condition     = aws_cloudtrail.this.kms_key_id == var.kms_key_arn
    error_message = "KMS key ID does not match input"
  }

  assert {
    condition     = aws_cloudtrail.this.is_multi_region_trail == true
    error_message = "Trail should be multi-region by default"
  }

  assert {
    condition     = aws_cloudtrail.this.tags["environment"] == "test"
    error_message = "Mandatory environment tag is missing or incorrect"
  }
}
