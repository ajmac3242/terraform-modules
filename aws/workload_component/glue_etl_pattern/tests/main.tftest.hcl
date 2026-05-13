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
}
