variables {
  name        = "test-vpc"
  cidr_block  = "10.1.0.0/16"
  kms_key_arn = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"
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

# Plan-only test to verify flow logs and defaults
run "verify_vpc_configuration" {
  command = plan

  assert {
    condition     = module.vpc.vpc_cidr_block == var.cidr_block
    error_message = "VPC CIDR block is incorrect"
  }

  assert {
    condition     = module.vpc.vpc_flow_log_enabled == true
    error_message = "VPC Flow Logs should be enabled"
  }

  assert {
    condition     = length(module.vpc.private_subnets) == 3
    error_message = "Expected 3 private subnets"
  }
}
