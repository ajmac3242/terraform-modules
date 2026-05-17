variables {
  cluster_id         = "test-redis"
  subnet_ids         = ["subnet-12345"]
  security_group_ids = ["sg-12345"]
  kms_key_arn        = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"
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
    condition     = aws_elasticache_replication_group.this.at_rest_encryption_enabled == "true"
    error_message = "At-rest encryption should be enabled"
  }

  assert {
    condition     = aws_elasticache_replication_group.this.tags["environment"] == "test" && aws_elasticache_replication_group.this.tags["owner"] == "test-owner" && aws_elasticache_replication_group.this.tags["project"] == "test-project" && aws_elasticache_replication_group.this.tags["cost_center"] == "test-cc"
    error_message = "Mandatory tags are missing or incorrect on ElastiCache replication group"
  }

  assert {
    condition     = aws_elasticache_subnet_group.this.tags["environment"] == "test" && aws_elasticache_subnet_group.this.tags["owner"] == "test-owner" && aws_elasticache_subnet_group.this.tags["project"] == "test-project" && aws_elasticache_subnet_group.this.tags["cost_center"] == "test-cc"
    error_message = "Mandatory tags are missing or incorrect on ElastiCache subnet group"
  }
}

run "valid_valkey_creation" {
  command = plan

  variables {
    cluster_id     = "test-valkey"
    engine         = "valkey"
    engine_version = "9.0"
  }

  assert {
    condition     = aws_elasticache_replication_group.this.engine == "valkey"
    error_message = "Engine should be valkey"
  }

  assert {
    condition     = aws_elasticache_replication_group.this.engine_version == "9.0"
    error_message = "Engine version should be 9.0"
  }
}
