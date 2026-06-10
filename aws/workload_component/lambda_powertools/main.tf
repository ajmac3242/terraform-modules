module "lambda" {
  source = "../../base_component/lambda"

  function_name  = var.function_name
  description    = var.description
  runtime        = var.runtime
  handler        = var.handler
  filename       = var.filename
  layers         = [var.powertools_layer_arn]
  kms_key_arn    = var.kms_key_arn
  vpc_config     = var.vpc_config


  environment_variables = {
    POWERTOOLS_SERVICE_NAME = var.service_name
    LOG_LEVEL               = var.log_level
  }

  tags = var.tags
}
