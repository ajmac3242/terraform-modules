output "state_machine_arn" {
  description = "The ARN of the state machine"
  value       = aws_sfn_state_machine.this.arn
}

output "state_machine_id" {
  description = "The ID of the state machine"
  value       = aws_sfn_state_machine.this.id
}
