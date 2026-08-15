provider "aws" {
  region                      = "us-east-1"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true
  access_key                  = "mock_access_key"
  secret_key                  = "mock_secret_key"
}

run "verify_resiliency_policy" {
  command = plan

  variables {
    policy_name = "test-resiliency-policy"
    tier        = "MissionCritical"
    description = "Test resiliency policy for mission critical applications"

    policy_az = {
      rpo = "1h"
      rto = "15m"
    }

    policy_hardware = {
      rpo = "1h"
      rto = "15m"
    }

    policy_software = {
      rpo = "1h"
      rto = "15m"
    }

    policy_region = {
      rpo = "24h"
      rto = "4h"
    }

    tags = {
      environment = "test"
      owner       = "platform-team"
      project     = "resilience"
      cost_center = "cc-1234"
    }
  }

  assert {
    condition     = aws_resiliencehub_resiliency_policy.this.name == "test-resiliency-policy"
    error_message = "Resiliency policy name does not match expected value"
  }

  assert {
    condition     = aws_resiliencehub_resiliency_policy.this.tier == "MissionCritical"
    error_message = "Resiliency policy tier does not match expected value"
  }

  assert {
    condition     = aws_resiliencehub_resiliency_policy.this.tags["environment"] == "test"
    error_message = "Mandatory tag 'environment' does not match expected value"
  }

  assert {
    condition     = aws_resiliencehub_resiliency_policy.this.tags["cost_center"] == "cc-1234"
    error_message = "Mandatory tag 'cost_center' does not match expected value"
  }
}
