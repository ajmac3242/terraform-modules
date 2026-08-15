resource "aws_resiliencehub_resiliency_policy" "this" {
  name                     = var.policy_name
  tier                     = var.tier
  description              = var.description
  data_location_constraint = var.data_location_constraint
  tags                     = var.tags

  policy {
    az {
      rpo = var.policy_az.rpo
      rto = var.policy_az.rto
    }

    hardware {
      rpo = var.policy_hardware.rpo
      rto = var.policy_hardware.rto
    }

    software {
      rpo = var.policy_software.rpo
      rto = var.policy_software.rto
    }

    dynamic "region" {
      for_each = var.policy_region != null ? [var.policy_region] : []
      content {
        rpo = region.value.rpo
        rto = region.value.rto
      }
    }
  }
}
