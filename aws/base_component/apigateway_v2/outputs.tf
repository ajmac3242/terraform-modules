output "api_id" {
  description = "The ID of the API Gateway"
  value       = aws_apigatewayv2_api.this.id
}

output "api_arn" {
  description = "The ARN of the API Gateway"
  value       = aws_apigatewayv2_api.this.arn
}

output "api_endpoint" {
  description = "The HTTP endpoint for the API"
  value       = aws_apigatewayv2_api.this.api_endpoint
}

output "execution_arn" {
  description = "The execution ARN of the API Gateway"
  value       = aws_apigatewayv2_api.this.execution_arn
}

output "stage_arn" {
  description = "The ARN of the API Gateway stage"
  value       = aws_apigatewayv2_stage.this.arn
}

output "log_group_arn" {
  description = "The ARN of the CloudWatch log group for access logs"
  value       = aws_cloudwatch_log_group.this.arn
}

output "tags" {
  description = "A map of tags assigned to the resource"
  value       = aws_apigatewayv2_api.this.tags
}
