output "alb_dns_name" {
  description = "The DNS name of the load balancer"
  value       = var.use_existing_alb ? null : module.alb[0].alb_dns_name
}

output "alb_arn" {
  description = "The ARN of the load balancer"
  value       = var.use_existing_alb ? null : module.alb[0].alb_arn
}

output "service_arn" {
  description = "The ARN of the ECS service"
  value       = module.ecs_fargate.service_arn
}

output "target_group_arn" {
  description = "The ARN of the Target Group"
  value       = aws_lb_target_group.this.arn
}

output "listener_rule_arn" {
  description = "The ARN of the listener rule"
  value       = aws_lb_listener_rule.this.arn
}
