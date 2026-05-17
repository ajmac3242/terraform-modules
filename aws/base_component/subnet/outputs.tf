output "subnet_id" {
  description = "The ID of the subnet"
  value       = aws_subnet.this.id
}

output "subnet_arn" {
  description = "The ARN of the subnet"
  value       = aws_subnet.this.arn
}

output "tags" {
  description = "A map of tags assigned to the resource"
  value       = aws_subnet.this.tags_all
}
