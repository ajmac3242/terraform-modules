# Lambda Function using base module
module "lambda" {
  source = "../../base_component/lambda"

  function_name = var.lambda_function_name
  description   = var.description
  handler       = var.lambda_handler
  runtime       = var.lambda_runtime
  filename      = var.lambda_source_path

  vpc_config = var.lambda_vpc_config

  aws_account_id = var.aws_account_id
  tags           = var.tags
}

# KMS Key for EventBridge DLQ if enabled
module "dlq_kms" {
  count  = var.enable_dlq ? 1 : 0
  source = "../../base_component/kms"

  name                 = "${var.name}-dlq-key"
  description          = "KMS key for EventBridge DLQ ${var.name}"
  admin_principal_arns = []
  usage_principal_arns = []
  aws_account_id       = var.aws_account_id

  tags = var.tags
}

# SQS DLQ if enabled
module "dlq" {
  count  = var.enable_dlq ? 1 : 0
  source = "../../base_component/sqs"

  name        = "${var.name}-dlq"
  kms_key_arn = module.dlq_kms[0].key_arn

  tags = var.tags
}

# EventBridge Rule and Target using base module
module "eventbridge" {
  source = "../../base_component/eventbridge"

  create_bus = false
  name       = var.event_bus_name

  rules = {
    (var.name) = {
      description         = var.description
      event_pattern       = var.event_pattern
      schedule_expression = var.schedule_expression
    }
  }

  targets = {
    "${var.name}/lambda-target" = {
      rule_name       = var.name
      arn             = module.lambda.function_arn
      dead_letter_arn = var.enable_dlq ? module.dlq[0].queue_arn : null
    }
  }

  aws_account_id = var.aws_account_id
  tags           = var.tags
}

# Lambda Permission for EventBridge to invoke
resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = module.lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = module.eventbridge.rule_arns[var.name]
}
