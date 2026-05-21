variables {
  name                = "test-asg"
  image_id            = "ami-12345678"
  vpc_zone_identifier = ["subnet-12345678", "subnet-87654321"]
  kms_key_arn         = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"
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

run "valid_asg_creation" {
  command = plan

  assert {
    condition     = aws_autoscaling_group.this.name == var.name
    error_message = "ASG name does not match expected value"
  }

  # Verify AMI propagation to ensure dynamic selection support
  assert {
    condition     = aws_launch_template.this.image_id == var.image_id
    error_message = "Launch Template image_id does not match expected value"
  }

  assert {
    condition     = tobool(aws_launch_template.this.block_device_mappings[0].ebs[0].encrypted) == true
    error_message = "EBS should be encrypted"
  }

  assert {
    condition     = aws_launch_template.this.block_device_mappings[0].ebs[0].kms_key_id == var.kms_key_arn
    error_message = "EBS KMS key ARN does not match expected value"
  }

  assert {
    condition     = alltrue([for k in ["environment", "owner", "project", "cost_center"] : anytrue([for t in aws_autoscaling_group.this.tag : t.key == k && t.value == var.tags[k]])])
    error_message = "Mandatory tags are missing or incorrect on ASG."
  }

  assert {
    condition     = aws_launch_template.this.tags["environment"] == "test" && aws_launch_template.this.tags["owner"] == "test-owner" && aws_launch_template.this.tags["project"] == "test-project" && aws_launch_template.this.tags["cost_center"] == "test-cc"
    error_message = "Mandatory tags are missing or incorrect on Launch Template."
  }
}
