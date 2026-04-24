output "api_endpoint" {
  description = "The HTTP API endpoint"
  value       = aws_apigatewayv2_api.this.api_endpoint
}

output "api_id" {
  description = "The ID of the API Gateway"
  value       = aws_apigatewayv2_api.this.id
}

output "api_arn" {
  description = "The ARN of the API Gateway"
  value       = aws_apigatewayv2_api.this.arn
}

output "function_arn" {
  description = "The ARN of the Lambda function"
  value       = module.lambda.function_arn
}

output "role_arn" {
  description = "The ARN of the IAM role used by the Lambda function"
  value       = module.lambda.role_arn
}

output "stage_id" {
  description = "The ID of the API Gateway stage"
  value       = aws_apigatewayv2_stage.this.id
}

output "route_id" {
  description = "The ID of the API Gateway route"
  value       = aws_apigatewayv2_route.this.id
}

output "authorizer_id" {
  description = "The ID of the API Gateway authorizer"
  value       = var.disable_authorizer ? null : aws_apigatewayv2_authorizer.this[0].id
}
