variables {
  name        = "test-sg"
  description = "A test security group"
  vpc_id      = "vpc-12345"
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

run "valid_sg_creation" {
  command = plan

  assert {
    condition     = aws_security_group.this.name == var.name
    error_message = "Security group name does not match expected value"
  }

  assert {
    condition     = aws_security_group.this.tags["environment"] == "test" && aws_security_group.this.tags["owner"] == "test-owner" && aws_security_group.this.tags["project"] == "test-project" && aws_security_group.this.tags["cost_center"] == "test-cc"
    error_message = "Mandatory tags are missing or incorrect on security group"
  }
}

run "invalid_ingress_rule" {
  command = plan

  variables {
    ingress_rules = [
      {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "Public HTTP"
      }
    ]
  }

  expect_failures = [
    var.ingress_rules
  ]
}
