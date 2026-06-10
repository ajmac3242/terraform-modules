# Composed Lambda function using the base module
module "lambda" {
  source = "../../base_component/lambda"

  function_name = var.name
  description   = var.description
  runtime       = var.runtime
  handler       = var.handler
  filename      = var.filename
  kms_key_arn   = var.kms_key_arn


  permissions_boundary_arn = var.permissions_boundary_arn

  tags = var.tags
}

# Composed API Gateway using the base module
module "api_gateway" {
  source = "../../base_component/apigateway_v2"

  name        = var.name
  kms_key_arn = var.kms_key_arn

  cors_configuration = var.cors_configuration
  domain_name        = var.domain_name
  certificate_arn    = var.certificate_arn

  tags = var.tags
}

# Integration between API Gateway and Lambda
resource "aws_apigatewayv2_integration" "this" {
  api_id           = module.api_gateway.api_id
  integration_type = "AWS_PROXY"

  integration_method = "POST"
  integration_uri    = module.lambda.invoke_arn
}

# API Gateway Authorizer
resource "aws_apigatewayv2_authorizer" "this" {
  count            = var.disable_authorizer ? 0 : 1
  api_id           = module.api_gateway.api_id
  authorizer_type  = "JWT"
  identity_sources = ["$request.header.Authorization"]
  name             = "${var.name}-authorizer"

  jwt_configuration {
    audience = var.jwt_audience
    issuer   = var.jwt_issuer
  }
}

# API Gateway Route
resource "aws_apigatewayv2_route" "this" {
  api_id    = module.api_gateway.api_id
  route_key = var.route_key

  target             = "integrations/${aws_apigatewayv2_integration.this.id}"
  authorization_type = var.disable_authorizer ? "NONE" : "JWT"
  authorizer_id      = var.disable_authorizer ? null : aws_apigatewayv2_authorizer.this[0].id
}

# Permission for API Gateway to invoke Lambda
resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowExecutionFromAPIGateway-${var.name}"
  action        = "lambda:InvokeFunction"
  function_name = module.lambda.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${module.api_gateway.execution_arn}/*/*"
}

# WAF association with API Gateway stage
resource "aws_wafv2_web_acl_association" "this" {
  resource_arn = module.api_gateway.stage_arn
  web_acl_arn  = var.waf_web_acl_arn
}
