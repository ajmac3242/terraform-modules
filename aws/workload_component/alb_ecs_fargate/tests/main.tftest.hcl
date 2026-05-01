variables {
  name                           = "test-alb-ecs"
  vpc_id                         = "vpc-12345678"
  private_subnet_ids             = ["subnet-12345678", "subnet-87654321"]
  public_subnet_ids              = ["subnet-11111111", "subnet-22222222"]
  container_image                = "nginx:latest"
  kms_key_arn                    = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"
  access_logs_bucket             = "test-log-bucket"
  ecs_service_security_group_ids = ["sg-12345678"]
  aws_account_id                 = "123456789012"

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

run "valid_composition" {
  command = plan

  assert {
    condition     = aws_lb_target_group.this.port == 80
    error_message = "Target group port should default to 80"
  }

  assert {
    condition     = aws_lb_target_group.this.tags["environment"] == "test" && aws_lb_target_group.this.tags["owner"] == "test-owner" && aws_lb_target_group.this.tags["project"] == "test-project" && aws_lb_target_group.this.tags["cost_center"] == "test-cc"
    error_message = "Mandatory tags are missing or incorrect on ALB target group"
  }

  assert {
    condition     = aws_lb_listener_rule.this.tags["environment"] == "test" && aws_lb_listener_rule.this.tags["owner"] == "test-owner" && aws_lb_listener_rule.this.tags["project"] == "test-project" && aws_lb_listener_rule.this.tags["cost_center"] == "test-cc"
    error_message = "Mandatory tags are missing or incorrect on ALB listener rule"
  }
}
