variables {
  cluster_identifier = "test-aurora-mysql"
  master_username    = "dbadmin"
  master_password    = "SecurePassword123!"
  vpc_id             = "vpc-12345678"
  vpc_cidr_block     = "10.0.0.0/16"
  private_subnet_ids = ["subnet-12345678", "subnet-87654321"]
  kms_key_arn        = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"

  enable_serverlessv2 = true
  serverlessv2_scaling_configuration = {
    min_capacity = 0.5
    max_capacity = 16.0
  }

  enable_kiro_mcp_integration = true

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

run "valid_aurora_mysql_creation" {
  command = plan

  assert {
    condition     = aws_rds_cluster.this.cluster_identifier == var.cluster_identifier
    error_message = "Cluster identifier does not match"
  }

  assert {
    condition     = aws_rds_cluster.this.engine == "aurora-mysql"
    error_message = "Engine is not aurora-mysql"
  }

  assert {
    condition     = aws_rds_cluster.this.storage_encrypted == true
    error_message = "Storage encryption is not enabled"
  }

  assert {
    condition     = aws_rds_cluster.this.kms_key_id == var.kms_key_arn
    error_message = "KMS Key ARN does not match"
  }

  assert {
    condition     = aws_rds_cluster.this.backup_retention_period == 7
    error_message = "Backup retention period is not at least 7 days"
  }

  assert {
    condition     = aws_rds_cluster.this.storage_type == "aurora-iopt1"
    error_message = "Storage type is not aurora-iopt1"
  }

  assert {
    condition     = aws_rds_cluster.this.iam_database_authentication_enabled == true
    error_message = "IAM database authentication is not enabled"
  }

  assert {
    condition     = aws_rds_cluster.this.serverlessv2_scaling_configuration[0].min_capacity == 0.5
    error_message = "Serverless v2 min capacity does not match"
  }

  assert {
    condition     = aws_rds_cluster.this.serverlessv2_scaling_configuration[0].max_capacity == 16.0
    error_message = "Serverless v2 max capacity does not match"
  }

  assert {
    condition     = aws_cloudwatch_log_group.this["audit"].kms_key_id == var.kms_key_arn
    error_message = "CloudWatch log group audit CMK encryption does not match"
  }

  assert {
    condition     = length(module.kiro_mcp_control_plane_role) == 1
    error_message = "Kiro MCP control plane role module was not created"
  }

  assert {
    condition     = length(module.kiro_mcp_data_plane_role) == 1
    error_message = "Kiro MCP data plane role module was not created"
  }

  assert {
    condition     = aws_rds_cluster.this.tags["environment"] == "test"
    error_message = "Mandatory tag environment is missing"
  }
}
