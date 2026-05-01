variables {
  vpc_id = "vpc-12345"
  region = "us-east-1"
  endpoints = {
    s3 = {
      service      = "s3"
      service_type = "Gateway"
    }
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

run "valid_endpoints_creation" {
  command = plan

  assert {
    condition     = length(aws_vpc_endpoint.this) == 1
    error_message = "Expected 1 VPC endpoint"
  }

  assert {
    condition     = aws_vpc_endpoint.this["s3"].service_name == "com.amazonaws.us-east-1.s3"
    error_message = "Service name is incorrect"
  }

  assert {
    condition     = aws_vpc_endpoint.this["s3"].tags["environment"] == "test" && aws_vpc_endpoint.this["s3"].tags["owner"] == "test-owner" && aws_vpc_endpoint.this["s3"].tags["project"] == "test-project" && aws_vpc_endpoint.this["s3"].tags["cost_center"] == "test-cc"
    error_message = "Mandatory tags are missing or incorrect on VPC endpoint"
  }
}
