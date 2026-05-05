variables {
  name            = "test-sagemaker"
  container_image = "123456789012.dkr.ecr.us-east-1.amazonaws.com/test-image:latest"
  kms_key_arn     = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"
  vpc_config = {
    subnets            = ["subnet-12345", "subnet-67890"]
    security_group_ids = ["sg-12345"]
  }
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

run "valid_sagemaker_creation" {
  command = plan

  assert {
    condition     = aws_sagemaker_model.this.name == var.name
    error_message = "SageMaker model name does not match expected value"
  }

  assert {
    condition     = aws_sagemaker_endpoint_configuration.this.kms_key_arn == var.kms_key_arn
    error_message = "KMS key ARN on Endpoint Configuration does not match"
  }

  assert {
    condition     = length(aws_sagemaker_model.this.vpc_config[0].subnets) == 2
    error_message = "VPC configuration subnets count is incorrect"
  }

  assert {
    condition     = aws_sagemaker_endpoint.this.tags["environment"] == "test" && aws_sagemaker_endpoint.this.tags["owner"] == "test-owner" && aws_sagemaker_endpoint.this.tags["project"] == "test-project" && aws_sagemaker_endpoint.this.tags["cost_center"] == "test-cc"
    error_message = "Mandatory tags are missing or incorrect on Endpoint"
  }

  assert {
    condition     = module.execution_role[0].tags["environment"] == "test"
    error_message = "Mandatory tags are missing or incorrect on Execution Role"
  }
}
