variable "name" {
  description = "Name of the Bedrock Guardrail"
  type        = string
}

variable "description" {
  description = "Description of the Bedrock Guardrail"
  type        = string
  default     = null
}

variable "blocked_input_messaging" {
  description = "Messaging for when input is blocked"
  type        = string
}

variable "blocked_outputs_messaging" {
  description = "Messaging for when output is blocked"
  type        = string
}

variable "kms_key_arn" {
  description = "The ARN of the KMS key used to encrypt the guardrail"
  type        = string
  validation {
    condition     = can(regex("^arn:aws:kms:[a-z0-9-]+:[0-9]{12}:key/.*$", var.kms_key_arn))
    error_message = "kms_key_arn must be a valid KMS key ARN."
  }
}

variable "content_policy_config" {
  description = "Configuration for content policy"
  type = object({
    filters_config = list(object({
      type            = string
      input_strength  = string
      output_strength = string
    }))
  })
  default = null
}

variable "topic_policy_config" {
  description = "Configuration for topic policy"
  type = object({
    topics_config = list(object({
      name       = string
      definition = string
      examples   = list(string)
      type       = string
    }))
  })
  default = null
}

variable "word_policy_config" {
  description = "Configuration for word policy"
  type = object({
    managed_word_lists_config = list(object({
      type = string
    }))
    words_config = list(object({
      text = string
    }))
  })
  default = null
}

variable "sensitive_information_policy_config" {
  description = "Configuration for sensitive information policy"
  type = object({
    pii_entities_config = list(object({
      type   = string
      action = string
    }))
    regexes_config = list(object({
      name        = string
      description = string
      pattern     = string
      action      = string
    }))
  })
  default = null
}

variable "contextual_grounding_policy_config" {
  description = "Configuration for contextual grounding policy"
  type = object({
    filters_config = list(object({
      type      = string
      threshold = number
    }))
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
