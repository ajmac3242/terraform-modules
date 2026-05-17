output "state_machine_arn" {
  description = "The ARN of the state machine"
  value       = try(aws_sfn_state_machine.this[0].arn, null)
}

output "state_machine_id" {
  description = "The ID of the state machine"
  value       = try(aws_sfn_state_machine.this[0].id, null)
}

output "tags" {
  description = "A map of tags assigned to the resources"
  value       = var.tags
}
