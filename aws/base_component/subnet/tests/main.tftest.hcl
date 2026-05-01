variables {
  name              = "test-subnet"
  vpc_id            = "vpc-12345"
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
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

run "valid_subnet_creation" {
  command = plan

  assert {
    condition     = aws_subnet.this.cidr_block == var.cidr_block
    error_message = "Subnet CIDR block does not match expected value"
  }

  assert {
    condition     = aws_subnet.this.tags["Name"] == var.name
    error_message = "Subnet Name tag is incorrect"
  }

  assert {
    condition     = aws_subnet.this.tags["environment"] == "test" && aws_subnet.this.tags["owner"] == "test-owner" && aws_subnet.this.tags["project"] == "test-project" && aws_subnet.this.tags["cost_center"] == "test-cc"
    error_message = "Mandatory tags are missing or incorrect on subnet"
  }
}
