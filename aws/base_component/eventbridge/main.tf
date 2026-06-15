# Automatically manage KMS key if not provided and creating a bus
module "kms" {
  count  = var.create_bus && var.existing_kms_key_arn == null && var.kms_key_arn == null ? 1 : 0
  source = "../kms"

  name                 = "${var.name}-bus-key"
  description          = "KMS key for EventBridge bus ${var.name}"
  admin_principal_arns = []
  usage_principal_arns = ["arn:aws:iam::${coalesce(var.aws_account_id, try(data.aws_caller_identity.current[0].account_id, ""))}:root"] # Basic usage for the account, actual service access via key policy usually needs more
  aws_account_id       = var.aws_account_id

  tags = var.tags
}

data "aws_caller_identity" "current" {
  count = var.aws_account_id == null ? 1 : 0
}

locals {
  account_id           = coalesce(var.aws_account_id, try(data.aws_caller_identity.current[0].account_id, ""))
  provided_kms_key_arn = var.existing_kms_key_arn != null ? var.existing_kms_key_arn : var.kms_key_arn
  kms_key_arn          = var.create_bus ? (local.provided_kms_key_arn != null ? local.provided_kms_key_arn : module.kms[0].key_arn) : null
}

# Main EventBridge Bus resource
resource "aws_cloudwatch_event_bus" "this" {
  count              = var.create_bus ? 1 : 0
  name               = var.name
  kms_key_identifier = local.kms_key_arn

  tags = var.tags
}

locals {
  bus_name = var.create_bus ? aws_cloudwatch_event_bus.this[0].name : (var.name != null ? var.name : "default")
}

# EventBridge Rules
resource "aws_cloudwatch_event_rule" "this" {
  for_each = var.rules

  name                = each.key
  description         = each.value.description
  event_bus_name      = local.bus_name
  event_pattern       = each.value.event_pattern
  schedule_expression = each.value.schedule_expression
  state               = each.value.state

  tags = var.tags
}

# Key policy for EventBridge service
resource "aws_kms_key_policy" "eventbridge" {
  count  = var.create_bus && var.existing_kms_key_arn == null && var.kms_key_arn == null ? 1 : 0
  key_id = module.kms[0].key_id
  policy = data.aws_iam_policy_document.kms_eventbridge[0].json
}

data "aws_iam_policy_document" "kms_eventbridge" {
  count = var.create_bus && var.existing_kms_key_arn == null && var.kms_key_arn == null ? 1 : 0

  statement {
    sid    = "Allow EventBridge to use the key"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }
    actions = [
      "kms:Decrypt",
      "kms:GenerateDataKey*"
    ]
    resources = ["*"]
  }

  # Inherit from module.kms if possible, or just add account root
  statement {
    sid    = "Enable IAM User Permissions"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${local.account_id}:root"]
    }
    actions   = ["kms:*"]
    resources = ["*"]
  }
}

# EventBridge Targets
resource "aws_cloudwatch_event_target" "this" {
  for_each = var.targets

  rule           = aws_cloudwatch_event_rule.this[each.value.rule_name].name
  target_id      = split("/", each.key)[1]
  arn            = each.value.arn
  event_bus_name = local.bus_name
  role_arn       = each.value.role_arn
  input          = each.value.input

  dynamic "dead_letter_config" {
    for_each = each.value.dead_letter_arn != null ? [1] : []
    content {
      arn = each.value.dead_letter_arn
    }
  }
}
