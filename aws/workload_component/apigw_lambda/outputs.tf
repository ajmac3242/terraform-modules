output "api_endpoint" {
  description = "The HTTP API endpoint"
  value       = aws_apigatewayv2_api.this.api_endpoint
}

output "api_id" {
  description = "The ID of the API Gateway"
  value       = aws_apigatewayv2_api.this.id
}

output "function_arn" {
  description = "The ARN of the Lambda function"
  value       = module.lambda.function_arn
}
