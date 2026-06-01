variables {
  cluster_identifier = "test-aurora"
  instance_class     = "db.t4g.medium"
  vpc_id             = "vpc-12345678"
  vpc_cidr_block     = "10.0.0.0/16"
  private_subnet_ids = ["subnet-12345678", "subnet-87654321"]
  kms_key_arn        = "arn:aws:kms:us-east-1:123456789012:key/test-key-id"
  master_username    = "dbadmin"
  master_password    = "SecurePassword123!"
  tags = {
    environment = "test"
    owner       = "test-owner"
    project     = "test-project"
    cost_center = "test-cc"
  }

  lambda_invocation_arns = ["arn:aws:lambda:us-east-1:123456789012:function:test-function"]
  s3_import_bucket_arn   = "arn:aws:s3:::test-bucket"
}

provider "aws" {
  region                      = "us-east-1"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true
  access_key                  = "mock_access_key"
  secret_key                  = "mock_secret_key"
}

run "valid_aurora_creation" {
  command = plan

  assert {
    condition     = aws_rds_cluster.this.cluster_identifier == var.cluster_identifier
    error_message = "Cluster identifier does not match"
  }

  assert {
    condition     = aws_rds_cluster.this.storage_encrypted == true
    error_message = "Storage encryption is not enabled"
  }

  assert {
    condition     = aws_rds_cluster.this.backup_retention_period == 7
    error_message = "Backup retention period is not 7 days"
  }

  assert {
    condition     = aws_rds_cluster.this.storage_type == "aurora-iopt1"
    error_message = "Storage type is not aurora-iopt1"
  }

  assert {
    condition     = length([for p in aws_rds_cluster_parameter_group.this.parameter : p if p.name == "rds.allowed_extensions" && p.value == "pgvector,aws_lambda,aws_s3"]) > 0
    error_message = "Parameter group settings for allowed extensions are incorrect"
  }

  assert {
    condition     = length(aws_rds_cluster_role_association.lambda) == 1
    error_message = "Lambda role association is missing"
  }

  assert {
    condition     = length(aws_rds_cluster_role_association.s3_import) == 1
    error_message = "S3 import role association is missing"
  }

  assert {
    condition     = aws_rds_cluster.this.tags["environment"] == "test"
    error_message = "Mandatory tags are missing on Aurora cluster"
  }
}
