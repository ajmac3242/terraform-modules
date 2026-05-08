variables {
  name               = "test-fargate"
  vpc_id             = "vpc-12345"
  private_subnet_ids = ["subnet-12345", "subnet-67890"]
  container_image    = "nginx:latest"
  kms_key_arn        = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"
  aws_account_id     = "123456789012"
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

  assert {
    condition     = aws_ecs_cluster.this.tags["environment"] == "test" && aws_ecs_cluster.this.tags["owner"] == "test-owner" && aws_ecs_cluster.this.tags["project"] == "test-project" && aws_ecs_cluster.this.tags["cost_center"] == "test-cc"
    error_message = "Mandatory tags are missing or incorrect on ECS cluster."
  }

  assert {
    condition     = aws_ecs_service.this.tags["environment"] == "test" && aws_ecs_service.this.tags["owner"] == "test-owner" && aws_ecs_service.this.tags["project"] == "test-project" && aws_ecs_service.this.tags["cost_center"] == "test-cc"
    error_message = "Mandatory tags are missing or incorrect on ECS service."
  }

  assert {
    condition     = aws_cloudwatch_log_group.this.tags["environment"] == "test" && aws_cloudwatch_log_group.this.tags["owner"] == "test-owner" && aws_cloudwatch_log_group.this.tags["project"] == "test-project" && aws_cloudwatch_log_group.this.tags["cost_center"] == "test-cc"
    error_message = "Mandatory tags are missing or incorrect on CloudWatch log group."
  }

  assert {
    condition     = jsondecode(aws_ecs_task_definition.this.container_definitions)[0].logConfiguration.options["awslogs-region"] == "us-east-1"
    error_message = "ECS task definition log region does not match expected value"
  }
}
