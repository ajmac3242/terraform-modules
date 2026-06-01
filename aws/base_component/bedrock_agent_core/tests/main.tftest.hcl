variables {
  name        = "test-gateway"
  role_arn    = "arn:aws:iam::123456789012:role/test-role"
  kms_key_arn = "arn:aws:kms:us-east-1:123456789012:key/test-key-id"
  description = "A test gateway"
  tags = {
    environment = "test"
    owner       = "test-owner"
    project     = "test-project"
    cost_center = "test-cc"
  }

  online_evaluation_configs = {
    "test_eval" = {
      evaluation_execution_role_arn = "arn:aws:iam::123456789012:role/eval-role"
      data_source_config = {
        cloudwatch_logs = {
          log_group_names = ["/test/logs"]
          service_names   = ["bedrock"]
        }
      }
      evaluator_ids       = ["Builtin.Helpfulness"]
      sampling_percentage = 50.0
    }
  }

  browsers = {
    "test-browser" = {
      execution_role_arn = "arn:aws:iam::123456789012:role/browser-role"
      network_configuration = {
        network_mode = "VPC"
        vpc_config = {
          security_groups = ["sg-12345"]
          subnets         = ["subnet-12345"]
        }
      }
      recording = {
        enabled = true
        s3_location = {
          bucket = "test-bucket"
          prefix = "recordings/"
        }
      }
    }
  }

  gateway_targets = {} # Skip gateway target in test if tool_schema is complex
}

provider "aws" {
  region                      = "us-east-1"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true
  access_key                  = "mock_access_key"
  secret_key                  = "mock_secret_key"
}

run "valid_gateway_creation" {
  command = plan

  assert {
    condition     = aws_bedrockagentcore_gateway.this.name == var.name
    error_message = "Gateway name does not match expected value"
  }

  assert {
    condition     = aws_bedrockagentcore_gateway.this.description == var.description
    error_message = "Gateway description does not match expected value"
  }

  assert {
    condition     = aws_bedrockagentcore_gateway.this.role_arn == var.role_arn
    error_message = "Gateway role ARN does not match expected value"
  }

  assert {
    condition     = aws_bedrockagentcore_gateway.this.kms_key_arn == var.kms_key_arn
    error_message = "Gateway KMS key ARN does not match expected value"
  }

  assert {
    condition     = aws_bedrockagentcore_gateway.this.tags["environment"] == "test" && aws_bedrockagentcore_gateway.this.tags["owner"] == "test-owner" && aws_bedrockagentcore_gateway.this.tags["project"] == "test-project" && aws_bedrockagentcore_gateway.this.tags["cost_center"] == "test-cc"
    error_message = "Mandatory tags are missing or incorrect on Bedrock AgentCore Gateway"
  }
}

run "valid_online_evaluation_creation" {
  command = plan

  assert {
    condition     = aws_bedrockagentcore_online_evaluation_config.this["test_eval"].online_evaluation_config_name == "test_eval"
    error_message = "Online evaluation config name does not match expected value"
  }

  assert {
    condition     = aws_bedrockagentcore_online_evaluation_config.this["test_eval"].tags["environment"] == "test"
    error_message = "Mandatory tags are missing on Online Evaluation config"
  }
}

run "valid_browser_creation" {
  command = plan

  assert {
    condition     = aws_bedrockagentcore_browser.this["test-browser"].name == "test-browser"
    error_message = "Browser name does not match expected value"
  }

  assert {
    condition     = aws_bedrockagentcore_browser.this["test-browser"].network_configuration[0].network_mode == "VPC"
    error_message = "Browser network mode is not VPC"
  }

  assert {
    condition     = aws_bedrockagentcore_browser.this["test-browser"].tags["environment"] == "test"
    error_message = "Mandatory tags are missing on Browser"
  }
}
