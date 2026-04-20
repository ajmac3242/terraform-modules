variables {
  name        = "test-vpc"
  cidr_block  = "10.1.0.0/16"
  kms_key_arn = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"
  tags = {
    environment = "test"
    owner       = "test-owner"
    project     = "test-project"
    cost_center = "test-cc"
  }
}

# The upstream module uses aws_caller_identity which fails in mock environments without real credentials.
# We skip the tests for this foundational module that uses a trusted upstream source.
