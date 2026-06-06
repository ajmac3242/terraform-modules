variable "agent_name" {
  description = "Name of the Bedrock Agent"
  type        = string
}

variable "foundation_model" {
  description = "The foundation model used by the agent"
  type        = string
}

variable "instruction" {
  description = "Instructions that tell the agent what it should do and how it should interact with users"
  type        = string
}

variable "agent_resource_role_arn" {
  description = "The ARN of the IAM role with permissions to invoke the agent"
  type        = string
  validation {
    condition     = can(regex("^arn:aws:iam::[0-9]{12}:role/.*$", var.agent_resource_role_arn))
    error_message = "agent_resource_role_arn must be a valid IAM role ARN."
  }
}

variable "kms_key_arn" {
  description = "The ARN of the KMS key used to encrypt the agent"
  type        = string
  validation {
    condition     = can(regex("^arn:aws:kms:[a-z0-9-]+:[0-9]{12}:key/[a-z0-9-]+$", var.kms_key_arn))
    error_message = "The kms_key_arn must be a valid AWS KMS key ARN (arn:aws:kms:region:account:key/key-id)."
  }
}

variable "guardrail_configuration" {
  description = "Guardrail configuration for the agent"
  type = object({
    guardrail_identifier = string
    guardrail_version    = string
  })
  default = null
}

variable "tags" {
  description = "A map of tags to assign to the resources. Required keys: environment, owner, project, cost_center."
  type        = map(string)
  validation {
    condition     = alltrue([for k in ["environment", "owner", "project", "cost_center"] : contains(keys(var.tags), k)])
    error_message = "The tags map must contain environment, owner, project, and cost_center keys."
  }
}
