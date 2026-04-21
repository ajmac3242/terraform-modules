variables {
  cluster_id         = "test-redis"
  subnet_ids         = ["subnet-12345"]
  security_group_ids = ["sg-12345"]
  kms_key_id         = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"
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

run "valid_elasticache_creation" {
  command = plan

  assert {
    condition     = aws_elasticache_replication_group.this.replication_group_id == var.cluster_id
    error_message = "Replication group ID does not match expected value"
  }

  assert {
    condition     = aws_elasticache_replication_group.this.at_rest_encryption_enabled == true
    error_message = "At-rest encryption should be enabled"
  }
}
