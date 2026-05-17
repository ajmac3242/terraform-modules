output "cluster_arn" {
  description = "The ARN of the ECS cluster"
  value       = aws_ecs_cluster.this.arn
}

output "service_arn" {
  description = "The ARN of the ECS service"
  value       = aws_ecs_service.this.id
}

output "task_definition_arn" {
  description = "The ARN of the task definition"
  value       = aws_ecs_task_definition.this.arn
}

output "tags" {
  description = "A map of tags assigned to the resource"
  value       = aws_ecs_cluster.this.tags_all
}
