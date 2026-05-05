output "model_arn" {
  description = "The ARN of the SageMaker model"
  value       = aws_sagemaker_model.this.arn
}

output "endpoint_configuration_arn" {
  description = "The ARN of the SageMaker endpoint configuration"
  value       = aws_sagemaker_endpoint_configuration.this.arn
}

output "endpoint_arn" {
  description = "The ARN of the SageMaker endpoint"
  value       = aws_sagemaker_endpoint.this.arn
}

output "endpoint_name" {
  description = "The name of the SageMaker endpoint"
  value       = aws_sagemaker_endpoint.this.name
}

output "execution_role_arn" {
  description = "The ARN of the IAM role used by SageMaker"
  value       = local.role_arn
}

output "tags" {
  description = "A map of tags assigned to the resource"
  value       = aws_sagemaker_endpoint.this.tags
}
