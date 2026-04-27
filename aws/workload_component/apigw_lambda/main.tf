# Composed Lambda function using the base module
module "lambda" {
  source = "../../base_component/lambda"

  function_name  = var.name
  description    = var.description
  runtime        = var.runtime
  handler        = var.handler
  filename       = var.filename
  kms_key_arn    = var.kms_key_arn
  aws_account_id = var.aws_account_id

  permissions_boundary_arn = var.permissions_boundary_arn

  tags = var.tags
}

# HTTP API Gateway resource
resource "aws_apigatewayv2_api" "this" {
  name          = var.name
  protocol_type = "HTTP"

  tags = var.tags
}

# Integration between API Gateway and Lambda
resource "aws_apigatewayv2_integration" "this" {
  api_id           = aws_apigatewayv2_api.this.id
  integration_type = "AWS_PROXY"

  integration_method = "POST"
  integration_uri    = module.lambda.invoke_arn
}

# API Gateway Authorizer
resource "aws_apigatewayv2_authorizer" "this" {
  count            = var.disable_authorizer ? 0 : 1
  api_id           = aws_apigatewayv2_api.this.id
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
  api_id    = aws_apigatewayv2_api.this.id
  route_key = var.route_key

  target             = "integrations/${aws_apigatewayv2_integration.this.id}"
  authorization_type = var.disable_authorizer ? "NONE" : "JWT"
  authorizer_id      = var.disable_authorizer ? null : aws_apigatewayv2_authorizer.this[0].id
}

# API Gateway Stage with auto-deploy and access logging
resource "aws_apigatewayv2_stage" "this" {
  api_id      = aws_apigatewayv2_api.this.id
  name        = "$default"
  auto_deploy = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_gw.arn
    format = jsonencode({
      requestId      = "$context.requestId"
      ip             = "$context.identity.sourceIp"
      requestTime    = "$context.requestTime"
      httpMethod     = "$context.httpMethod"
      routeKey       = "$context.routeKey"
      status         = "$context.status"
      protocol       = "$context.protocol"
      responseLength = "$context.responseLength"
    })
  }

  tags = var.tags
}

# Encrypted log group for API Gateway access logs
resource "aws_cloudwatch_log_group" "api_gw" {
  name              = "/aws/apigateway/${var.name}"
  retention_in_days = 30
  kms_key_id        = var.kms_key_arn

  tags = var.tags
}

# Permission for API Gateway to invoke Lambda
resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowExecutionFromAPIGateway-${var.name}"
  action        = "lambda:InvokeFunction"
  function_name = module.lambda.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.this.execution_arn}/*/*"
}

# WAF association with API Gateway stage
resource "aws_wafv2_web_acl_association" "this" {
  resource_arn = aws_apigatewayv2_stage.this.arn
  web_acl_arn  = var.waf_web_acl_arn
}
