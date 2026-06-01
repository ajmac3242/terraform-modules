variables {
  rule_name      = "test-rule"
  telemetry_type = "Traces"
  resource_type  = "AWS::Lambda::Function"
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

run "valid_telemetry_rule_creation" {
  command = plan

  assert {
    condition     = aws_observabilityadmin_telemetry_rule.this[0].rule_name == var.rule_name
    error_message = "Rule name does not match expected value"
  }

  assert {
    condition     = aws_observabilityadmin_telemetry_rule.this[0].rule[0].telemetry_type == var.telemetry_type
    error_message = "Telemetry type does not match"
  }

  assert {
    condition     = aws_observabilityadmin_telemetry_rule.this[0].rule[0].resource_type == var.resource_type
    error_message = "Resource type does not match"
  }

  assert {
    condition     = aws_observabilityadmin_telemetry_rule.this[0].tags["environment"] == "test" && aws_observabilityadmin_telemetry_rule.this[0].tags["owner"] == "test-owner" && aws_observabilityadmin_telemetry_rule.this[0].tags["project"] == "test-project" && aws_observabilityadmin_telemetry_rule.this[0].tags["cost_center"] == "test-cc"
    error_message = "Mandatory tags are missing or incorrect"
  }
}

run "valid_organization_telemetry_rule_creation" {
  command = plan

  variables {
    is_organization_rule = true
  }

  assert {
    condition     = aws_observabilityadmin_telemetry_rule_for_organization.this[0].rule_name == var.rule_name
    error_message = "Organization rule name does not match expected value"
  }

  assert {
    condition     = aws_observabilityadmin_telemetry_rule_for_organization.this[0].rule[0].telemetry_type == var.telemetry_type
    error_message = "Organization telemetry type does not match"
  }

  assert {
    condition     = aws_observabilityadmin_telemetry_rule_for_organization.this[0].tags["environment"] == "test"
    error_message = "Mandatory tags are missing on organization rule"
  }
}
