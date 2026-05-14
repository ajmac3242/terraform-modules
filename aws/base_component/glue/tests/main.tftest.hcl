variables {
  name        = "test-glue"
  role_arn    = "arn:aws:iam::123456789012:role/test-glue-role"
  kms_key_arn = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"
  s3_targets = [
    { path = "s3://test-bucket/data/" }
  ]
  command_script_location = "s3://test-bucket/scripts/test.py"
  vpc_config = {
    subnet_ids         = ["subnet-12345"]
    security_group_ids = ["sg-12345"]
  }
  tags = {
    environment = "test"
    owner       = "builder"
    project     = "unit-test"
    cost_center = "0000"
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

run "validate_tags" {
  command = plan

  assert {
    condition     = aws_glue_catalog_database.this.tags["environment"] == "test"
    error_message = "Mandatory tag 'environment' is missing or incorrect on catalog database."
  }

  assert {
    condition     = aws_glue_crawler.this[0].tags["owner"] == "builder"
    error_message = "Mandatory tag 'owner' is missing or incorrect on crawler."
  }

  assert {
    condition     = aws_glue_job.this[0].tags["project"] == "unit-test"
    error_message = "Mandatory tag 'project' is missing or incorrect on job."
  }

  assert {
    condition     = aws_glue_connection.this[0].tags["cost_center"] == "0000"
    error_message = "Mandatory tag 'cost_center' is missing or incorrect on connection."
  }
}

run "validate_encryption" {
  command = plan

  assert {
    condition     = aws_glue_security_configuration.this.encryption_configuration[0].cloudwatch_encryption[0].kms_key_arn == var.kms_key_arn
    error_message = "CloudWatch encryption must use the provided CMK."
  }

  assert {
    condition     = aws_glue_security_configuration.this.encryption_configuration[0].job_bookmarks_encryption[0].kms_key_arn == var.kms_key_arn
    error_message = "Job bookmarks encryption must use the provided CMK."
  }

  assert {
    condition     = aws_glue_security_configuration.this.encryption_configuration[0].s3_encryption[0].kms_key_arn == var.kms_key_arn
    error_message = "S3 encryption must use the provided CMK."
  }

  assert {
    condition     = aws_glue_data_catalog_encryption_settings.this.data_catalog_encryption_settings[0].encryption_at_rest[0].catalog_encryption_mode == "SSE-KMS"
    error_message = "Data catalog encryption mode must be SSE-KMS."
  }

  assert {
    condition     = aws_glue_data_catalog_encryption_settings.this.data_catalog_encryption_settings[0].encryption_at_rest[0].sse_aws_kms_key_id == var.kms_key_arn
    error_message = "Data catalog encryption must use the provided CMK."
  }
}

run "validate_vpc_config" {
  command = plan

  assert {
    condition     = aws_glue_connection.this[0].connection_type == "NETWORK"
    error_message = "Glue connection type must be NETWORK."
  }

  assert {
    condition     = aws_glue_connection.this[0].physical_connection_requirements[0].subnet_id == var.vpc_config.subnet_ids[0]
    error_message = "Glue connection must use the provided subnet ID."
  }
}
