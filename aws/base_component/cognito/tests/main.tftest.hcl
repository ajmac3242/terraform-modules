variables {
  user_pool_name = "test-user-pool"
  client_name    = "test-client"
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

run "valid_cognito_creation" {
  command = plan

  assert {
    condition     = aws_cognito_user_pool.this.name == var.user_pool_name
    error_message = "User Pool name does not match"
  }

  assert {
    condition     = aws_cognito_user_pool.this.user_pool_add_ons[0].advanced_security_mode == "ENFORCED"
    error_message = "Advanced security mode should be ENFORCED by default"
  }

  assert {
    condition     = aws_cognito_user_pool_client.this.generate_secret == false
    error_message = "Client secret should not be generated for SPAs by default"
  }
}
