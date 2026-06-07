data "aws_region" "current" {}
# Main resource definitions for Security Hub


data "aws_caller_identity" "current" {}

resource "aws_securityhub_account" "this" {
  enable_default_standards  = var.enable_default_standards
  control_finding_generator = var.control_finding_generator
  auto_enable_controls      = var.auto_enable_controls
}

resource "aws_securityhub_standards_subscription" "this" {
  for_each = toset(var.standards_subscriptions)

  standards_arn = each.value
  depends_on    = [aws_securityhub_account.this]
}

resource "aws_securityhub_finding_aggregator" "this" {
  count = var.enable_finding_aggregator ? 1 : 0

  linking_mode      = "ALL_REGIONS"
  specified_regions = null

  depends_on = [aws_securityhub_account.this]
}
