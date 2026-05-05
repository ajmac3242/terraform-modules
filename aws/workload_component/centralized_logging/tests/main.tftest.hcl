variables {
  name_prefix    = "test-logs"
  aws_account_id = "123456789012"
  alb_account_id = "127311923021"
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

run "valid_centralized_logging_creation" {
  command = plan

  assert {
    condition     = module.log_storage.tags["environment"] == "test" && module.log_analysis.tags["owner"] == "test-owner"
    error_message = "Mandatory tags are missing or incorrect on logging resources."
  }
}
