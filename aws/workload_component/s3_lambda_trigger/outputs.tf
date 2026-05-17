output "bucket_id" {
  description = "The name of the bucket"
  value       = module.s3.bucket_id
}

output "bucket_arn" {
  description = "The ARN of the bucket"
  value       = module.s3.bucket_arn
}

output "function_arn" {
  description = "The ARN of the Lambda function"
  value       = module.lambda.function_arn
}

output "function_name" {
  description = "The name of the Lambda function"
  value       = module.lambda.function_name
}

output "notification_id" {
  description = "The ID of the S3 bucket notification"
  value       = aws_s3_bucket_notification.this.id
}

output "tags" {
  description = "A map of tags assigned to the resources"
  value       = var.tags
}
