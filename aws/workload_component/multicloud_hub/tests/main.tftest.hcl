variables {
  name           = "test-hub"
  cloud_provider = "OCI"
  bandwidth      = "1Gbps"
  location       = "EqDC2"
  vlan           = 100
  kms_key_arn    = "arn:aws:kms:us-east-1:123456789012:key/mrk-1234abcd"
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

run "valid_multicloud_hub_creation" {
  command = plan

  assert {
    condition     = aws_ec2_transit_gateway.this.amazon_side_asn == 64512
    error_message = "Transit Gateway ASN does not match expected value"
  }

  assert {
    condition     = aws_cloudwatch_log_group.this.kms_key_id == var.kms_key_arn
    error_message = "CloudWatch Log Group is not encrypted with the provided CMK"
  }

  assert {
    condition     = aws_ec2_transit_gateway.this.tags["environment"] == "test" && aws_ec2_transit_gateway.this.tags["owner"] == "test-owner" && aws_ec2_transit_gateway.this.tags["project"] == "test-project" && aws_ec2_transit_gateway.this.tags["cost_center"] == "test-cc"
    error_message = "Mandatory tags are missing or incorrect on Transit Gateway"
  }
}
