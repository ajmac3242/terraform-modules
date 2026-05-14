variables {
  name            = "test-etl-pattern"
  kms_key_arn     = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"
  etl_script_path = "etl_dummy.py"
  vpc_config = {
    subnet_ids         = ["subnet-12345678"]
    security_group_ids = ["sg-12345678"]
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

run "validate_composition" {
  command = plan

  assert {
    condition     = module.glue.database_name == var.name
    error_message = "Glue database name should match the provided name."
  }
}

run "validate_security" {
  command = plan

  assert {
    condition     = aws_iam_policy.glue_s3_kms.name == "${var.name}-glue-s3-kms-policy"
    error_message = "IAM policy for Glue should be created with correct name."
  }

  assert {
    condition     = module.glue_role.role_name == "${var.name}-glue-role"
    error_message = "IAM role for Glue should be created with correct name."
  }
}

run "validate_tags" {
  command = plan

  assert {
    condition     = module.raw_bucket.tags["environment"] == "test"
    error_message = "Tag 'environment' missing on raw bucket."
  }

  assert {
    condition     = module.glue.tags["owner"] == "builder"
    error_message = "Tag 'owner' missing on Glue module."
  }

  assert {
    condition     = aws_iam_policy.glue_s3_kms.tags["project"] == "unit-test"
    error_message = "Tag 'project' missing on IAM policy."
  }

  assert {
    condition     = module.glue_role.tags["cost_center"] == "0000"
    error_message = "Tag 'cost_center' missing on Glue role."
  }
}
