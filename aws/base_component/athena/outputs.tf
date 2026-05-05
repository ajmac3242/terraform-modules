output "workgroup_arn" {
  description = "The ARN of the Athena workgroup"
  value       = aws_athena_workgroup.this.arn
}

output "workgroup_id" {
  description = "The ID of the Athena workgroup"
  value       = aws_athena_workgroup.this.id
}

output "workgroup_name" {
  description = "The name of the Athena workgroup"
  value       = aws_athena_workgroup.this.id
}

output "tags" {
  description = "The tags assigned to the resource"
  value       = aws_athena_workgroup.this.tags_all
}
