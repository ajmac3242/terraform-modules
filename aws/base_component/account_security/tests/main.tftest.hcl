variables {
  vpc_id = "vpc-12345678"
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

override_data {
  target = data.aws_caller_identity.current
  values = {
    account_id = "123456789012"
    arn        = "arn:aws:iam::123456789012:root"
    userid     = "123456789012"
  }
}

run "validate_account_security" {
  command = plan

  assert {
    condition     = aws_s3_account_public_access_block.this[0].block_public_acls == true
    error_message = "S3 account public access block must be enabled."
  }

  assert {
    condition     = aws_ec2_instance_metadata_defaults.this[0].http_tokens == "required"
    error_message = "IMDSv2 must be required."
  }

  assert {
    condition     = aws_ec2_instance_metadata_defaults.this[0].http_put_response_hop_limit == 1
    error_message = "IMDS hop limit must be 1."
  }

  assert {
    condition     = aws_ebs_encryption_by_default.this[0].enabled == true
    error_message = "EBS encryption by default must be enabled."
  }

  assert {
    condition     = aws_iam_account_password_policy.this[0].minimum_password_length == 14
    error_message = "IAM password policy minimum length must be 14."
  }

  assert {
    condition     = aws_accessanalyzer_analyzer.this[0].type == "ACCOUNT"
    error_message = "IAM Access Analyzer must be of type ACCOUNT."
  }

  assert {
    condition     = aws_accessanalyzer_analyzer.this[0].tags["environment"] == "test" && aws_accessanalyzer_analyzer.this[0].tags["owner"] == "test-owner" && aws_accessanalyzer_analyzer.this[0].tags["project"] == "test-project" && aws_accessanalyzer_analyzer.this[0].tags["cost_center"] == "test-cc"
    error_message = "Mandatory tags are missing or incorrect on Access Analyzer."
  }

  assert {
    condition     = aws_guardduty_detector.this[0].tags["environment"] == "test" && aws_guardduty_detector.this[0].tags["owner"] == "test-owner" && aws_guardduty_detector.this[0].tags["project"] == "test-project" && aws_guardduty_detector.this[0].tags["cost_center"] == "test-cc"
    error_message = "Mandatory tags are missing or incorrect on GuardDuty detector."
  }

  assert {
    condition     = !var.enable_guardduty || (aws_guardduty_detector_feature.s3_logs[0].status == "ENABLED" && aws_guardduty_detector_feature.s3_logs[0].name == "S3_DATA_EVENTS")
    error_message = "GuardDuty S3 data events feature must be enabled when GuardDuty is enabled."
  }

  assert {
    condition     = !var.enable_guardduty || (aws_guardduty_detector_feature.kubernetes[0].status == (var.enable_guardduty_kubernetes ? "ENABLED" : "DISABLED") && aws_guardduty_detector_feature.kubernetes[0].name == "EKS_AUDIT_LOGS")
    error_message = "GuardDuty EKS audit logs feature status does not match enable_guardduty_kubernetes."
  }

  assert {
    condition     = !var.enable_guardduty || (aws_guardduty_detector_feature.malware_protection[0].status == "ENABLED" && aws_guardduty_detector_feature.malware_protection[0].name == "EBS_MALWARE_PROTECTION")
    error_message = "GuardDuty EBS malware protection feature must be enabled when GuardDuty is enabled."
  }

  assert {
    condition     = aws_default_security_group.this[0].tags["environment"] == "test" && aws_default_security_group.this[0].tags["owner"] == "test-owner" && aws_default_security_group.this[0].tags["project"] == "test-project" && aws_default_security_group.this[0].tags["cost_center"] == "test-cc"
    error_message = "Mandatory tags are missing or incorrect on default security group."
  }

  assert {
    condition     = aws_ec2_serial_console_access.this.enabled == false
    error_message = "EC2 serial console access must be disabled."
  }

  assert {
    condition     = module.support_role[0].role_name == "aws-support-access-role"
    error_message = "IAM Support role must be created with the correct name."
  }
}
