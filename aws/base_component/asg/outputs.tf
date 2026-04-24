output "asg_id" {
  description = "The ID of the ASG"
  value       = aws_autoscaling_group.this.id
}

output "asg_arn" {
  description = "The ARN of the ASG"
  value       = aws_autoscaling_group.this.arn
}

output "launch_template_id" {
  description = "The ID of the launch template"
  value       = aws_launch_template.this.id
}

output "launch_template_arn" {
  description = "The ARN of the launch template"
  value       = aws_launch_template.this.arn
}
