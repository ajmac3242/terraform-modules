variables {
  identifier     = "test-db"
  engine         = "postgres"
  engine_version = "15.3"
  db_name        = "testdb"
  username       = "testadmin"
  password       = "testpassword"
  subnet_ids     = ["subnet-12345", "subnet-67890"]
  vpc_security_group_ids = ["sg-12345"]
  kms_key_id     = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"
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

run "valid_rds_creation" {
  command = plan

  assert {
    condition     = aws_db_instance.this.identifier == var.identifier
    error_message = "RDS identifier does not match expected value"
  }

  assert {
    condition     = aws_db_instance.this.storage_encrypted == true
    error_message = "Storage should be encrypted"
  }

  assert {
    condition     = aws_db_instance.this.multi_az == true
    error_message = "Multi-AZ should be enabled by default"
  }
}
