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
    condition     = can(regex("^arn:aws:kms:[a-z0-9-]+:[0-9]{12}:key/.*$", var.kms_key_arn))
    error_message = "kms_key_arn must be a valid KMS key ARN."
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

variable "create_browser" {
  description = "Whether to create a Bedrock AgentCore Browser tool."
  type        = bool
  default     = false
}

variable "browser_name" {
  description = "The name of the browser tool."
  type        = string
  default     = null
}

variable "browser_description" {
  description = "Description of the browser tool."
  type        = string
  default     = null
}

variable "browser_execution_role_arn" {
  description = "The ARN of the IAM role that the browser tool uses."
  type        = string
  default     = null
  validation {
    condition     = var.browser_execution_role_arn == null || can(regex("^arn:aws:iam::[0-9]{12}:role/.*$", var.browser_execution_role_arn))
    error_message = "browser_execution_role_arn must be a valid IAM role ARN."
  }
}

variable "browser_vpc_config" {
  description = "VPC configuration for the browser tool."
  type = object({
    network_mode = string
    vpc_config = optional(object({
      security_groups = set(string)
      subnets         = set(string)
    }))
  })
  default = null
}

variable "browser_recording_config" {
  description = "Recording configuration for the browser tool."
  type = object({
    enabled = optional(bool)
    s3_location = optional(object({
      bucket = string
      prefix = string
    }))
  })
  default = null
}

variable "targets" {
  description = "A map of gateway targets to create."
  type = map(object({
    name        = string
    description = optional(string)
    credential_provider_configuration = optional(object({
      api_key = optional(object({
        provider_arn              = string
        credential_location       = optional(string)
        credential_parameter_name = optional(string)
        credential_prefix         = optional(string)
      }))
      gateway_iam_role = optional(bool, false)
      oauth = optional(object({
        provider_arn       = string
        grant_type         = string
        custom_parameters  = optional(map(string))
        default_return_url = optional(string)
        scopes             = optional(list(string))
      }))
    }))
    target_configuration = optional(object({
      mcp = optional(object({
        lambda = optional(object({
          lambda_arn = string
        }))
        mcp_server = optional(object({
          endpoint = string
        }))
      }))
    }))
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
