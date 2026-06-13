variable "name" {
  description = "The name of the Bedrock AgentCore Gateway."
  type        = string
}

variable "role_arn" {
  description = "The ARN of the IAM role that the gateway uses to access AWS resources."
  type        = string
  validation {
    condition     = can(regex("^arn:aws:iam::[0-9]{12}:role/.*$", var.role_arn))
    error_message = "role_arn must be a valid IAM role ARN."
  }
}

variable "kms_key_arn" {
  description = "The ARN of the KMS key used for encryption at rest. Mandatory per repository standards."
  type        = string
  validation {
    condition     = can(regex("^arn:aws:kms:[a-z0-9-]+:[0-9]{12}:key/[a-z0-9-]+$", var.kms_key_arn))
    error_message = "The KMS key ARN must be a valid AWS KMS key ARN."
  }
}

variable "description" {
  description = "Description of the gateway."
  type        = string
  default     = null
}

variable "authorizer_type" {
  description = "The type of authorizer for the gateway. Valid values: CUSTOM_JWT, NONE."
  type        = string
  default     = "NONE"
  validation {
    condition     = contains(["CUSTOM_JWT", "NONE"], var.authorizer_type)
    error_message = "authorizer_type must be one of: CUSTOM_JWT, NONE."
  }
}

variable "authorizer_configuration" {
  description = "Configuration for request authorization. Required when authorizer_type is set to CUSTOM_JWT."
  type = object({
    custom_jwt_authorizer = object({
      discovery_url = string
    })
  })
  default = null
}

variable "protocol_type" {
  description = "The type of protocol for the gateway. Valid values: MCP."
  type        = string
  default     = "MCP"
  validation {
    condition     = contains(["MCP"], var.protocol_type)
    error_message = "protocol_type must be: MCP."
  }
}

variable "protocol_configuration" {
  description = "Configuration for the gateway protocol."
  type = object({
    mcp = object({
      instructions       = optional(string)
      search_type        = optional(string)
      supported_versions = optional(list(string))
    })
  })
  default = null
}

variable "online_evaluation_configs" {
  description = "A map of Online Evaluation configurations to create."
  type = map(object({
    description                   = optional(string)
    evaluation_execution_role_arn = string
    enable_on_create              = optional(bool, true)
    data_source_config = object({
      cloudwatch_logs = object({
        log_group_names = list(string)
        service_names   = list(string)
      })
    })
    evaluator_ids       = list(string)
    sampling_percentage = optional(number)
  }))
  default = {}

  validation {
    condition = alltrue([
      for k, v in var.online_evaluation_configs : (
        v.sampling_percentage == null || (v.sampling_percentage >= 0 && v.sampling_percentage <= 100)
      )
    ])
    error_message = "sampling_percentage must be between 0 and 100."
  }
}

variable "browsers" {
  description = "A map of Bedrock AgentCore Browsers to create."
  type = map(object({
    description        = optional(string)
    execution_role_arn = string
    network_configuration = object({
      network_mode = string
      vpc_config = object({
        security_groups = list(string)
        subnets         = list(string)
      })
    })
    recording = optional(object({
      enabled = bool
      s3_location = object({
        bucket = string
        prefix = optional(string)
      })
    }))
  }))
  default = {}
}

variable "gateway_targets" {
  description = "A map of Gateway Targets to create for tool orchestration."
  type = map(object({
    description = optional(string)
    target_configuration = object({
      mcp = object({
        lambda = optional(object({
          lambda_arn = string
        }))
      })
    })
  }))
  default = {}
}

variable "tags" {
  description = "A map of tags to assign to the resources. Required keys: environment, owner, project, cost_center."
  type        = map(string)
  validation {
    condition     = alltrue([for k in ["environment", "owner", "project", "cost_center"] : contains(keys(var.tags), k)])
    error_message = "The tags map must contain environment, owner, project, and cost_center keys."
  }
}
