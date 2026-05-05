variables {
  name           = "test-interconnect"
  cloud_provider = "OCI"
  bandwidth      = "1Gbps"
  location       = "EqDC2"
  vlan           = 100
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

run "valid_interconnect_creation" {
  command = plan

  assert {
    condition     = aws_dx_gateway.this.name == var.name
    error_message = "DX Gateway name does not match expected value"
  }

  assert {
    condition     = aws_dx_connection.this.bandwidth == var.bandwidth
    error_message = "Bandwidth does not match expected value"
  }

  assert {
    condition     = aws_dx_private_virtual_interface.this.vlan == var.vlan
    error_message = "VLAN ID does not match expected value"
  }

  assert {
    condition     = aws_dx_connection.this.tags["environment"] == "test" && aws_dx_connection.this.tags["owner"] == "test-owner" && aws_dx_connection.this.tags["project"] == "test-project" && aws_dx_connection.this.tags["cost_center"] == "test-cc"
    error_message = "Mandatory tags are missing or incorrect on Connection"
  }
}
