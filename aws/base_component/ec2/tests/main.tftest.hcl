variables {
  name        = "test-ec2"
  ami         = "ami-12345678"
  subnet_id   = "subnet-12345678"
  kms_key_arn = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"
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

run "valid_ec2_creation" {
  command = plan

  assert {
    condition     = aws_instance.this.ami == var.ami
    error_message = "AMI does not match expected value"
  }

  assert {
    condition     = aws_instance.this.root_block_device[0].encrypted == true
    error_message = "Root EBS should be encrypted"
  }
}
