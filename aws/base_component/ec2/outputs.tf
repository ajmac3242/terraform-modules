output "instance_id" {
  description = "The ID of the instance"
  value       = aws_instance.this.id
}

output "instance_arn" {
  description = "The ARN of the instance"
  value       = aws_instance.this.arn
}

output "private_ip" {
  description = "The private IP address assigned to the instance"
  value       = aws_instance.this.private_ip
}

output "tags" {
  description = "A map of tags assigned to the resource"
  value       = aws_instance.this.tags_all
}
