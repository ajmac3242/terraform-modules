variables {
  vpc_id = "vpc-12345678"
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

run "validate_account_security" {
  command = plan

  assert {
    condition     = aws_s3_account_public_access_block.this[0].block_public_acls == true
    error_message = "S3 account public access block must be enabled."
  }

  assert {
    condition     = aws_ec2_instance_metadata_defaults.this[0].http_tokens == "required"
    error_message = "IMDSv2 must be required."
  }

  assert {
    condition     = aws_ec2_instance_metadata_defaults.this[0].http_put_response_hop_limit == 1
    error_message = "IMDS hop limit must be 1."
  }
}
