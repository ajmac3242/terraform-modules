variable "name" {
  description = "The name of the guardrail"
  type        = string
}

variable "description" {
  description = "A description of the guardrail"
  type        = string
  default     = null
}

variable "blocked_input_messaging" {
  description = "The message to return when input is blocked"
  type        = string
}

variable "blocked_outputs_messaging" {
  description = "The message to return when output is blocked"
  type        = string
}

variable "kms_key_arn" {
  description = "The ARN of the KMS key for encryption"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:kms:[a-z0-9-]+:[0-9]{12}:key/[a-z0-9-]+$", var.kms_key_arn))
    error_message = "The kms_key_arn must be a valid AWS KMS key ARN (arn:aws:kms:region:account:key/key-id)."
  }
}

variable "content_policy_config" {
  description = "Content policy config for a guardrail"
  type = list(object({
    filters_config = list(object({
      type            = string
      input_strength  = string
      output_strength = string
    }))
  }))
  default = []
}

variable "topic_policy_config" {
  description = "Topic policy config for a guardrail"
  type = list(object({
    topics_config = list(object({
      name       = string
      definition = string
      examples   = optional(list(string))
      type       = string
    }))
  }))
  default = []
}

variable "word_policy_config" {
  description = "Word policy config for a guardrail"
  type = list(object({
    managed_word_lists_config = optional(list(object({
      type = string
    })))
    words_config = optional(list(object({
      text = string
    })))
  }))
  default = []
}

variable "sensitive_information_policy_config" {
  description = "Sensitive information policy config for a guardrail"
  type = list(object({
    pii_entities_config = optional(list(object({
      type   = string
      action = string
    })))
    regexes_config = optional(list(object({
      name        = string
      description = optional(string)
      pattern     = string
      action      = string
    })))
  }))
  default = []
}

variable "contextual_grounding_policy_config" {
  description = "Contextual grounding policy config for a guardrail"
  type = list(object({
    filters_config = list(object({
      type      = string
      threshold = number
    }))
  }))
  default = []
}

variable "tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)

  validation {
    condition     = contains(keys(var.tags), "environment") && contains(keys(var.tags), "owner") && contains(keys(var.tags), "project") && contains(keys(var.tags), "cost_center")
    error_message = "The tags map must contain the following keys: environment, owner, project, cost_center."
  }
}
