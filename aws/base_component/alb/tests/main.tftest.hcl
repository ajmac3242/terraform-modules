variables {
  name               = "test-alb"
  subnets            = ["subnet-12345678", "subnet-87654321"]
  security_groups    = ["sg-12345678"]
  access_logs_bucket = "test-log-bucket"
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

run "valid_alb_creation" {
  command = plan

  assert {
    condition     = aws_lb.this.name == var.name
    error_message = "ALB name does not match expected value"
  }

  assert {
    condition     = aws_lb.this.load_balancer_type == "application"
    error_message = "LB type should be application"
  }
}
