variables {
  name        = "test-lattice"
  vpc_id      = "vpc-1234567890abcdef0"
  kms_key_arn = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"
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
    condition     = aws_vpclattice_service_network.this.tags["environment"] == "test"
    error_message = "Mandatory tag 'environment' is missing or incorrect on service network."
  }

  assert {
    condition     = aws_vpclattice_service.this.tags["owner"] == "builder"
    error_message = "Mandatory tag 'owner' is missing or incorrect on service."
  }

  assert {
    condition     = aws_vpclattice_service_network_vpc_association.this.tags["project"] == "unit-test"
    error_message = "Mandatory tag 'project' is missing or incorrect on VPC association."
  }

  assert {
    condition     = aws_vpclattice_service_network_service_association.this.tags["cost_center"] == "0000"
    error_message = "Mandatory tag 'cost_center' is missing or incorrect on service association."
  }

  assert {
    condition     = aws_cloudwatch_log_group.this.tags["environment"] == "test"
    error_message = "Mandatory tag 'environment' is missing or incorrect on log group."
  }
}

run "validate_encryption" {
  command = plan

  assert {
    condition     = aws_cloudwatch_log_group.this.kms_key_id == var.kms_key_arn
    error_message = "CloudWatch Log Group must be encrypted with the provided CMK."
  }
}

run "validate_associations" {
  command = plan

  assert {
    condition     = aws_vpclattice_service_network_vpc_association.this.vpc_identifier == var.vpc_id
    error_message = "VPC association is not using the correct VPC ID."
  }
}
