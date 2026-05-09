provider "aws" {
  region = "us-east-1"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
  access_key                  = "mock_access_key"
  secret_key                  = "mock_secret_key"
}

run "validate_backup_module" {
  command = plan

  variables {
    name        = "test-backup"
    kms_key_arn = "arn:aws:kms:us-east-1:123456789012:key/00000000-0000-0000-0000-000000000000"

    rules = [
      {
        rule_name = "daily"
        schedule  = "cron(0 12 * * ? *)"
        lifecycle = {
          delete_after = 30
        }
      }
    ]

    vault_lock_configuration = {
      min_retention_days = 7
    }

    selection_resources = [
      "arn:aws:ec2:us-east-1:123456789012:instance/i-0123456789abcdef0"
    ]

    tags = {
      environment = "test"
      owner       = "test-owner"
      project     = "test-project"
      cost_center = "test-cc"
    }
  }

  assert {
    condition     = aws_backup_vault.this.kms_key_arn == "arn:aws:kms:us-east-1:123456789012:key/00000000-0000-0000-0000-000000000000"
    error_message = "Backup vault is not using the specified CMK."
  }

  assert {
    condition     = aws_backup_vault_lock_configuration.this[0].min_retention_days == 7
    error_message = "Backup vault lock configuration is incorrect."
  }

  assert {
    condition     = aws_backup_plan.this.name == "test-backup"
    error_message = "Backup plan name is incorrect."
  }

  assert {
    condition     = alltrue([for k in ["environment", "owner", "project", "cost_center"] : contains(keys(aws_backup_vault.this.tags), k)])
    error_message = "Mandatory tags are missing from the backup vault."
  }

  assert {
    condition     = alltrue([for k in ["environment", "owner", "project", "cost_center"] : contains(keys(aws_backup_plan.this.tags), k)])
    error_message = "Mandatory tags are missing from the backup plan."
  }
}
