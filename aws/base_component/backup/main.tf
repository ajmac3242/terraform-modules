# IAM role for AWS Backup
module "backup_iam_role" {
  source = "../iam"

  role_name   = "${var.name}-backup-role"
  description = "IAM role for AWS Backup service"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "backup.amazonaws.com"
        }
      }
    ]
  })

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup",
    "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForRestores"
  ]

  tags = var.tags
}

# Backup Vault
resource "aws_backup_vault" "this" {
  name        = var.name
  kms_key_arn = var.kms_key_arn

  tags = var.tags
}

# Backup Vault Lock Configuration
resource "aws_backup_vault_lock_configuration" "this" {
  count = var.vault_lock_configuration != null ? 1 : 0

  backup_vault_name   = aws_backup_vault.this.name
  changeable_for_days = var.vault_lock_configuration.changeable_for_days
  max_retention_days  = var.vault_lock_configuration.max_retention_days
  min_retention_days  = var.vault_lock_configuration.min_retention_days
}

# Backup Plan
resource "aws_backup_plan" "this" {
  name = var.name

  dynamic "rule" {
    for_each = var.rules
    content {
      rule_name           = rule.value.rule_name
      target_vault_name   = rule.value.target_vault_name != null ? rule.value.target_vault_name : aws_backup_vault.this.name
      schedule            = rule.value.schedule
      start_window        = rule.value.start_window
      completion_window   = rule.value.completion_window
      recovery_point_tags = rule.value.recovery_point_tags

      dynamic "lifecycle" {
        for_each = rule.value.lifecycle != null ? [rule.value.lifecycle] : []
        content {
          cold_storage_after = lifecycle.value.cold_storage_after
          delete_after       = lifecycle.value.delete_after
        }
      }

      dynamic "copy_action" {
        for_each = rule.value.copy_action != null ? rule.value.copy_action : []
        content {
          destination_vault_arn = copy_action.value.destination_vault_arn
          dynamic "lifecycle" {
            for_each = copy_action.value.lifecycle != null ? [copy_action.value.lifecycle] : []
            content {
              cold_storage_after = lifecycle.value.cold_storage_after
              delete_after       = lifecycle.value.delete_after
            }
          }
        }
      }
    }
  }

  tags = var.tags
}

# Backup Selection
resource "aws_backup_selection" "this" {
  iam_role_arn = module.backup_iam_role.role_arn
  name         = "${var.name}-selection"
  plan_id      = aws_backup_plan.this.id

  resources = var.selection_resources

  dynamic "selection_tag" {
    for_each = var.selection_tags
    content {
      type  = selection_tag.value.type
      key   = selection_tag.value.key
      value = selection_tag.value.value
    }
  }
}
