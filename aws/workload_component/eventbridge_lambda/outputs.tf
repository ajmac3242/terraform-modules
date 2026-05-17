output "rule_arn" {
  description = "The ARN of the EventBridge rule"
  value       = module.eventbridge.rule_arns[var.name]
}

output "function_arn" {
  description = "The ARN of the Lambda function"
  value       = module.lambda.function_arn
}

output "function_name" {
  description = "The name of the Lambda function"
  value       = module.lambda.function_name
}

output "dlq_arn" {
  description = "The ARN of the dead-letter queue, if enabled"
  value       = var.enable_dlq ? module.dlq[0].queue_arn : null
}

output "tags" {
  description = "A map of tags assigned to the resources"
  value       = var.tags
}
