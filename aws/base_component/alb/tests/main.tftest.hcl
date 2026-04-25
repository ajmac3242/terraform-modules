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

  assert {
    condition     = aws_lb.this.enable_deletion_protection == true
    error_message = "Deletion protection should be enabled by default"
  }
}

run "https_listener_creation" {
  command = plan

  variables {
    enable_https_listener = true
    certificate_arn       = "arn:aws:acm:us-east-1:123456789012:certificate/12345678-1234-1234-1234-123456789012"
  }

  assert {
    condition     = length(aws_lb_listener.https) == 1
    error_message = "HTTPS listener should be created"
  }

  assert {
    condition     = aws_lb_listener.https[0].protocol == "HTTPS"
    error_message = "HTTPS listener protocol should be HTTPS"
  }
}

run "http_redirect_creation" {
  command = plan

  variables {
    enable_https_listener = true
    certificate_arn       = "arn:aws:acm:us-east-1:123456789012:certificate/12345678-1234-1234-1234-123456789012"
    enable_http_redirect  = true
  }

  assert {
    condition     = length(aws_lb_listener.http) == 1
    error_message = "HTTP redirect listener should be created"
  }

  assert {
    condition     = aws_lb_listener.http[0].default_action[0].type == "redirect"
    error_message = "HTTP listener should have redirect action"
  }
}
