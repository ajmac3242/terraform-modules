output "state_machine_arn" {
  description = "The ARN of the state machine"
  value       = try(module.step_functions[0].state_machine_arn, null)
}

output "state_machine_name" {
  description = "The name of the state machine"
  value       = var.name
}

output "role_arn" {
  description = "The ARN of the IAM role for the state machine"
  value       = module.role.role_arn
}

output "lambda_function_arns" {
  description = "List of Lambda function ARNs associated with the pattern"
  value       = var.lambda_arns
}

output "tags" {
  description = "A map of tags assigned to the resources"
  value       = var.tags
}
