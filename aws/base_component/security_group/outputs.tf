output "security_group_id" {
  description = "The ID of the security group"
  value       = aws_security_group.this.id
}

output "security_group_arn" {
  description = "The ARN of the security group"
  value       = aws_security_group.this.arn
}

output "tags" {
  description = "A map of tags assigned to the resource"
  value       = aws_security_group.this.tags_all
}
