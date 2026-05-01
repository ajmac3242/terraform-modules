variables {
  name           = "test-bus"
  aws_account_id = "123456789012"
  tags = {
    environment = "test"
    owner       = "test-owner"
    project     = "test-project"
    cost_center = "test-cc"
  }
  rules = {
    "test-rule" = {
      description   = "Test rule"
      event_pattern = "{\"source\":[\"test\"]}"
    }
  }
  targets = {
    "test-rule/test-target" = {
      rule_name = "test-rule"
      arn       = "arn:aws:lambda:us-east-1:123456789012:function:test"
    }
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

run "valid_eventbridge_creation" {
  command = plan

  assert {
    condition     = length(aws_cloudwatch_event_bus.this) == 1
    error_message = "Event bus should be created"
  }

  assert {
    condition     = length(module.kms) == 1
    error_message = "KMS module should be enabled when creating a bus"
  }

  assert {
    condition     = length(aws_cloudwatch_event_rule.this) == 1
    error_message = "Event rule should be created"
  }

  assert {
    condition     = length(aws_cloudwatch_event_target.this) == 1
    error_message = "Event target should be created"
  }

  assert {
    condition     = aws_cloudwatch_event_bus.this[0].tags["environment"] == "test" && aws_cloudwatch_event_bus.this[0].tags["owner"] == "test-owner" && aws_cloudwatch_event_bus.this[0].tags["project"] == "test-project" && aws_cloudwatch_event_bus.this[0].tags["cost_center"] == "test-cc"
    error_message = "Mandatory tags are missing or incorrect on EventBridge bus"
  }

  assert {
    condition     = aws_cloudwatch_event_rule.this["test-rule"].tags["environment"] == "test" && aws_cloudwatch_event_rule.this["test-rule"].tags["owner"] == "test-owner" && aws_cloudwatch_event_rule.this["test-rule"].tags["project"] == "test-project" && aws_cloudwatch_event_rule.this["test-rule"].tags["cost_center"] == "test-cc"
    error_message = "Mandatory tags are missing or incorrect on EventBridge rule"
  }
}

run "default_bus_usage" {
  command = plan

  variables {
    create_bus = false
    name       = null
  }

  assert {
    condition     = length(aws_cloudwatch_event_bus.this) == 0
    error_message = "Event bus should not be created"
  }

  assert {
    condition     = aws_cloudwatch_event_rule.this["test-rule"].event_bus_name == "default"
    error_message = "Rule should be on default bus"
  }
}

run "provided_deprecated_kms_key" {
  command = plan

  variables {
    kms_key_arn = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"
  }

  assert {
    condition     = length(module.kms) == 0
    error_message = "KMS module should be disabled when kms_key_arn is provided"
  }

  assert {
    condition     = aws_cloudwatch_event_bus.this[0].kms_key_identifier == var.kms_key_arn
    error_message = "Event bus should use provided kms_key_arn"
  }
}
