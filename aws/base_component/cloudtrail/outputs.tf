output "trail_arn" {
  description = "The ARN of the trail"
  value       = aws_cloudtrail.this.arn
}

output "trail_id" {
  description = "The ID of the trail"
  value       = aws_cloudtrail.this.id
}

output "trail_home_region" {
  description = "The region in which the trail was created"
  value       = aws_cloudtrail.this.home_region
}

output "tags" {
  description = "A map of tags assigned to the resource"
  value       = aws_cloudtrail.this.tags
}
