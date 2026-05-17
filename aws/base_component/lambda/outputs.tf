output "function_arn" {
  description = "The ARN of the Lambda function"
  value       = aws_lambda_function.this.arn
}

output "function_name" {
  description = "The name of the Lambda function"
  value       = aws_lambda_function.this.function_name
}

output "role_arn" {
  description = "The ARN of the IAM role used by the Lambda function"
  value       = var.existing_role_arn != null ? var.existing_role_arn : module.execution_role[0].role_arn
}

output "invoke_arn" {
  description = "The ARN to be used for invoking the Lambda function from API Gateway"
  value       = aws_lambda_function.this.invoke_arn
}

output "log_group_name" {
  description = "The name of the CloudWatch log group"
  value       = aws_cloudwatch_log_group.this.name
}

output "kms_key_arn" {
  description = "The ARN of the KMS key used for encryption"
  value       = local.kms_key_arn
}

output "layers" {
  description = "List of Lambda Layer Version ARNs attached to the function"
  value       = aws_lambda_function.this.layers
}

output "environment_variables" {
  description = "A map of environment variables assigned to the Lambda function"
  value       = length(aws_lambda_function.this.environment) > 0 ? aws_lambda_function.this.environment[0].variables : {}
}

output "tags" {
  description = "A map of tags assigned to the Lambda function"
  value       = aws_lambda_function.this.tags
}
