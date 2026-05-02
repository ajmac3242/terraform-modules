output "pipe_arn" {
  description = "The ARN of the EventBridge Pipe"
  value       = aws_pipes_pipe.this.arn
}

output "pipe_id" {
  description = "The ID of the EventBridge Pipe"
  value       = aws_pipes_pipe.this.id
}

output "pipe_name" {
  description = "The name of the EventBridge Pipe"
  value       = aws_pipes_pipe.this.name
}

output "role_arn" {
  description = "The ARN of the IAM role created for the pipe"
  value       = module.iam_role.role_arn
}
