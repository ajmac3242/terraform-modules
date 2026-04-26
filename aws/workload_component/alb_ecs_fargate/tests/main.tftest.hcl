variables {
  name                           = "test-alb-ecs"
  vpc_id                         = "vpc-12345678"
  private_subnet_ids             = ["subnet-12345678", "subnet-87654321"]
  public_subnet_ids              = ["subnet-11111111", "subnet-22222222"]
  container_image                = "nginx:latest"
  kms_key_arn                    = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"
  access_logs_bucket             = "test-log-bucket"
  ecs_service_security_group_ids = ["sg-12345678"]

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
}
