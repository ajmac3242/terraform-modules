variables {
  name                 = "test-ecr"
  existing_kms_key_arn = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"
  aws_account_id       = "123456789012"
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

run "valid_ecr_creation" {
  command = plan

  assert {
    condition     = aws_ecr_repository.this.name == var.name
    error_message = "ECR name does not match expected value"
  }

  assert {
    condition     = aws_ecr_repository.this.encryption_configuration[0].encryption_type == "KMS"
    error_message = "Encryption type should be KMS"
  }

  assert {
    condition     = aws_ecr_repository.this.encryption_configuration[0].kms_key == var.existing_kms_key_arn
    error_message = "KMS key ARN does not match expected value"
  }

  assert {
    condition     = aws_ecr_repository.this.image_tag_mutability == "IMMUTABLE"
    error_message = "Image tag mutability should be IMMUTABLE by default"
  }

  assert {
    condition     = aws_ecr_repository.this.image_scanning_configuration[0].scan_on_push == true
    error_message = "Scan on push should be enabled by default"
  }
}

run "valid_ecr_creation_auto_kms" {
  command = plan

  variables {
    existing_kms_key_arn = null
  }

  assert {
    condition     = length(module.kms) == 1
    error_message = "KMS module should be enabled when existing_kms_key_arn is null"
  }
}
