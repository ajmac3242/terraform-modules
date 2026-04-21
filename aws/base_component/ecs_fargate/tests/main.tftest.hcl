variables {
  name               = "test-fargate"
  vpc_id             = "vpc-12345"
  private_subnet_ids = ["subnet-12345", "subnet-67890"]
  container_image    = "nginx:latest"
  kms_key_arn        = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"
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

run "valid_fargate_creation" {
  command = plan

  assert {
    condition     = aws_ecs_cluster.this.name == var.name
    error_message = "ECS cluster name does not match expected value"
  }

  assert {
    condition     = aws_ecs_service.this.launch_type == "FARGATE"
    error_message = "Service should use FARGATE launch type"
  }

  assert {
    condition     = aws_cloudwatch_log_group.this.kms_key_id == var.kms_key_arn
    error_message = "Log group KMS key does not match expected value"
  }
}
