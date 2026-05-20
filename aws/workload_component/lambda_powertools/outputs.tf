output "function_arn" {
  description = "The ARN of the Lambda function"
  value       = module.lambda.function_arn
}

output "function_name" {
  description = "The name of the Lambda function"
  value       = module.lambda.function_name
}

output "role_arn" {
  description = "The ARN of the execution role"
  value       = module.lambda.role_arn
}

output "log_group_name" {
  description = "The name of the CloudWatch Log Group"
  value       = module.lambda.log_group_name
}

output "tags" {
  description = "A map of tags assigned to the resource"
  value       = module.lambda.tags
}
