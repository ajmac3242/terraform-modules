variables {
  bucket_name          = "test-bucket"
  aws_account_id       = "123456789012"
  existing_kms_key_arn = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"
  log_bucket_id        = "test-log-bucket"
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

run "valid_bucket_creation" {
  command = plan

  assert {
    condition     = aws_s3_bucket.this.bucket == var.bucket_name
    error_message = "S3 bucket name does not match expected value"
  }

  assert {
    condition     = aws_s3_bucket_versioning.this.versioning_configuration[0].status == "Enabled"
    error_message = "S3 versioning should be enabled by default"
  }

  assert {
    condition     = aws_s3_bucket_public_access_block.this.block_public_acls == true
    error_message = "Public access block should be enabled"
  }

  assert {
    condition     = aws_s3_bucket.this.tags["environment"] == "test" && aws_s3_bucket.this.tags["owner"] == "test-owner" && aws_s3_bucket.this.tags["project"] == "test-project" && aws_s3_bucket.this.tags["cost_center"] == "test-cc"
    error_message = "Mandatory tags are missing or incorrect on S3 bucket"
  }

  assert {
    condition     = alltrue([for r in aws_s3_bucket_server_side_encryption_configuration.this.rule : r.apply_server_side_encryption_by_default[0].sse_algorithm == "aws:kms"])
    error_message = "S3 bucket must use KMS encryption"
  }
}
