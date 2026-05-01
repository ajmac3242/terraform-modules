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

run "valid_vpc_creation" {
  command = plan

  assert {
    condition     = module.vpc.vpc_cidr_block == var.cidr_block
    error_message = "VPC CIDR block does not match expected value"
  }

  assert {
    condition     = module.vpc.tags["environment"] == "test" && module.vpc.tags["owner"] == "test-owner" && module.vpc.tags["project"] == "test-project" && module.vpc.tags["cost_center"] == "test-cc"
    error_message = "Mandatory tags are missing or incorrect on VPC"
  }
}
