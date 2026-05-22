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

  # Verify AMI propagation to ensure dynamic selection support
  assert {
    condition     = aws_instance.this.ami == var.ami
    error_message = "AMI propagation failed"
  }

  assert {
    condition     = aws_instance.this.root_block_device[0].encrypted == true
    error_message = "Root EBS should be encrypted"
  }

  assert {
    condition     = aws_instance.this.root_block_device[0].kms_key_id == var.kms_key_arn
    error_message = "Root EBS KMS key ARN does not match expected value"
  }

  assert {
    condition     = aws_instance.this.tags["environment"] == "test" && aws_instance.this.tags["owner"] == "test-owner" && aws_instance.this.tags["project"] == "test-project" && aws_instance.this.tags["cost_center"] == "test-cc"
    error_message = "Mandatory tags are missing or incorrect on EC2 instance."
  }

  assert {
    condition     = aws_instance.this.metadata_options[0].http_tokens == "required"
    error_message = "IMDSv2 (http_tokens) must be required"
  }

  assert {
    condition     = aws_instance.this.metadata_options[0].http_put_response_hop_limit == 1
    error_message = "IMDS hop limit must be 1"
  }
}
