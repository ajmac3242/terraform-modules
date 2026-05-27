mock_provider "aws" {}

variables {
  name        = "test-gateway"
  role_arn    = "arn:aws:iam::123456789012:role/test-role"
  kms_key_arn = "arn:aws:kms:us-east-1:123456789012:key/test-key"
  tags = {
    environment = "test"
    owner       = "platform-team"
    project     = "infrastructure-modernization"
    cost_center = "12345"
  }

  create_browser             = true
  browser_name               = "test-browser"
  browser_description        = "Test Browser Tool"
  browser_execution_role_arn = "arn:aws:iam::123456789012:role/browser-role"
  browser_vpc_config = {
    network_mode = "VPC"
    vpc_config = {
      security_groups = ["sg-12345678"]
      subnets         = ["subnet-12345678"]
    }
  }
  browser_recording_config = {
    enabled = true
    s3_location = {
      bucket = "test-recording-bucket"
      prefix = "recordings/"
    }
  }

  targets = {
    mcp-target = {
      name        = "test-mcp-target"
      description = "Test MCP Target"
      target_configuration = {
        mcp = {
          mcp_server = {
            endpoint = "https://mcp.example.com"
          }
        }
      }
    }
  }
}

run "validate_browser_and_targets" {
  command = plan

  assert {
    condition     = aws_bedrockagentcore_browser.this[0].name == "test-browser"
    error_message = "Browser tool name does not match input."
  }

  assert {
    condition     = aws_bedrockagentcore_browser.this[0].network_configuration[0].network_mode == "VPC"
    error_message = "Browser network mode does not match input."
  }

  assert {
    condition     = aws_bedrockagentcore_browser.this[0].recording[0].enabled == true
    error_message = "Browser recording should be enabled."
  }

  assert {
    condition     = aws_bedrockagentcore_gateway_target.this["mcp-target"].name == "test-mcp-target"
    error_message = "Gateway target name does not match input."
  }

  assert {
    condition     = aws_bedrockagentcore_browser.this[0].tags["environment"] == "test"
    error_message = "Mandatory tags not propagated to browser tool."
  }
}
