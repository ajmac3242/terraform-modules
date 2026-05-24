variables {
  cluster_identifier   = "test-cluster"
  instance_class       = "db.r6g.large"
  instances_count      = 1
  vpc_id               = "vpc-12345678"
  vpc_cidr_block       = "10.0.0.0/16"
  private_subnet_ids   = ["subnet-11111111", "subnet-22222222"]
  kms_key_arn          = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"
  master_username      = "testadmin"
  master_password      = "testpassword"
  s3_import_bucket_arn = "arn:aws:s3:::test-bucket"
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

run "valid_aurora_creation" {
  command = plan

  assert {
    condition     = aws_rds_cluster.this.cluster_identifier == var.cluster_identifier
    error_message = "Cluster identifier does not match expected value"
  }

  assert {
    condition     = aws_rds_cluster.this.storage_encrypted == true
    error_message = "Storage should be encrypted"
  }

  assert {
    condition     = aws_rds_cluster.this.kms_key_id == var.kms_key_arn
    error_message = "KMS Key ARN does not match"
  }

  assert {
    condition     = aws_rds_cluster_instance.this[0].instance_class == var.instance_class
    error_message = "Instance class does not match"
  }

  assert {
    condition     = aws_rds_cluster_role_association.s3_import[0].feature_name == "s3Import"
    error_message = "Feature name should be s3Import"
  }

  assert {
    condition     = aws_security_group.this.description == "Security group for Aurora PostgreSQL cluster ${var.cluster_identifier}"
    error_message = "Security group description does not match"
  }

  assert {
    condition     = one(aws_security_group.this.ingress).cidr_blocks[0] == var.vpc_cidr_block
    error_message = "Security group ingress CIDR block does not match VPC CIDR block"
  }

  assert {
    condition     = one(aws_security_group.this.ingress).from_port == 5432
    error_message = "Security group ingress port does not match 5432"
  }

  assert {
    condition     = aws_db_subnet_group.this.subnet_ids == toset(var.private_subnet_ids)
    error_message = "DB Subnet Group subnet IDs do not match private_subnet_ids"
  }

  assert {
    condition     = aws_rds_cluster.this.tags["environment"] == "test" && aws_rds_cluster.this.tags["owner"] == "test-owner" && aws_rds_cluster.this.tags["project"] == "test-project" && aws_rds_cluster.this.tags["cost_center"] == "test-cc"
    error_message = "Mandatory tags are missing or incorrect on cluster"
  }
}
