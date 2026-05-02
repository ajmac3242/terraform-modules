provider "aws" {
  region                      = "us-east-1"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true
  access_key                  = "mock_access_key"
  secret_key                  = "mock_secret_key"
}

variables {
  name        = "test-collection"
  kms_key_arn = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"

  vpc_endpoint_ids = [
    "vpce-1234567890abcdef0"
  ]

  data_access_principals = [
    "arn:aws:iam::123456789012:role/test-role"
  ]

  tags = {
    environment = "test"
    owner       = "builder"
    project     = "unit-test"
    cost_center = "00000"
  }
}

run "validate_collection" {
  command = plan

  assert {
    condition     = aws_opensearchserverless_collection.this.name == "test-collection"
    error_message = "Collection name does not match input"
  }

  assert {
    condition     = aws_opensearchserverless_collection.this.type == "VECTORSEARCH"
    error_message = "Collection type is not VECTORSEARCH"
  }

  assert {
    condition     = aws_opensearchserverless_collection.this.tags["environment"] == "test" && aws_opensearchserverless_collection.this.tags["owner"] == "builder" && aws_opensearchserverless_collection.this.tags["project"] == "unit-test" && aws_opensearchserverless_collection.this.tags["cost_center"] == "00000"
    error_message = "Mandatory tags missing or incorrect on collection"
  }
}

run "validate_encryption_policy" {
  command = plan

  assert {
    condition     = can(regex("KmsKeyArn\":\"arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012\"", aws_opensearchserverless_security_policy.encryption.policy))
    error_message = "Encryption policy does not use the provided KMS key"
  }

  assert {
    condition     = aws_opensearchserverless_security_policy.encryption.type == "encryption"
    error_message = "Encryption policy type is incorrect"
  }
}

run "validate_network_policy" {
  command = plan

  assert {
    condition     = can(regex("AllowFromPublic\":false", aws_opensearchserverless_security_policy.network.policy))
    error_message = "Network policy allows public access"
  }

  assert {
    condition     = can(regex("SourceVPCEndpoints\":\\[\"vpce-1234567890abcdef0\"\\]", aws_opensearchserverless_security_policy.network.policy))
    error_message = "Network policy does not restrict to provided VPC endpoints"
  }
}

run "validate_access_policy" {
  command = plan

  assert {
    condition     = can(regex("Principal\":\\[\"arn:aws:iam::123456789012:role/test-role\"\\]", aws_opensearchserverless_access_policy.data.policy))
    error_message = "Access policy does not include the provided principals"
  }
}
