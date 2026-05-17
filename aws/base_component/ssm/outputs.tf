output "parameter_arn" {
  description = "The ARN of the SSM parameter"
  value       = aws_ssm_parameter.this.arn
}

output "parameter_name" {
  description = "The name of the SSM parameter"
  value       = aws_ssm_parameter.this.name
}

output "tags" {
  description = "A map of tags assigned to the resource"
  value       = aws_ssm_parameter.this.tags_all
}
