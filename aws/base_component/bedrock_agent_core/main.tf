resource "aws_bedrockagentcore_gateway" "this" {
  name            = var.name
  role_arn        = var.role_arn
  kms_key_arn     = var.kms_key_arn
  description     = var.description
  authorizer_type = var.authorizer_type
  protocol_type   = var.protocol_type

  dynamic "authorizer_configuration" {
    for_each = var.authorizer_configuration != null ? [var.authorizer_configuration] : []
    content {
      dynamic "custom_jwt_authorizer" {
        for_each = authorizer_configuration.value.custom_jwt_authorizer != null ? [authorizer_configuration.value.custom_jwt_authorizer] : []
        content {
          discovery_url = custom_jwt_authorizer.value.discovery_url
        }
      }
    }
  }

  dynamic "protocol_configuration" {
    for_each = var.protocol_configuration != null ? [var.protocol_configuration] : []
    content {
      dynamic "mcp" {
        for_each = protocol_configuration.value.mcp != null ? [protocol_configuration.value.mcp] : []
        content {
          instructions       = mcp.value.instructions
          search_type        = mcp.value.search_type
          supported_versions = mcp.value.supported_versions
        }
      }
    }
  }

  tags = var.tags
}

resource "aws_bedrockagentcore_gateway_target" "this" {
  for_each = var.targets

  gateway_identifier = aws_bedrockagentcore_gateway.this.gateway_id
  name               = each.value.name
  description        = each.value.description

  dynamic "credential_provider_configuration" {
    for_each = each.value.credential_provider_configuration != null ? [each.value.credential_provider_configuration] : []
    content {
      dynamic "api_key" {
        for_each = credential_provider_configuration.value.api_key != null ? [credential_provider_configuration.value.api_key] : []
        content {
          provider_arn              = api_key.value.provider_arn
          credential_location       = api_key.value.credential_location
          credential_parameter_name = api_key.value.credential_parameter_name
          credential_prefix         = api_key.value.credential_prefix
        }
      }
      dynamic "gateway_iam_role" {
        for_each = credential_provider_configuration.value.gateway_iam_role ? [1] : []
        content {}
      }
      dynamic "oauth" {
        for_each = credential_provider_configuration.value.oauth != null ? [credential_provider_configuration.value.oauth] : []
        content {
          provider_arn       = oauth.value.provider_arn
          grant_type         = oauth.value.grant_type
          custom_parameters  = oauth.value.custom_parameters
          default_return_url = oauth.value.default_return_url
          scopes             = oauth.value.scopes
        }
      }
    }
  }

  dynamic "target_configuration" {
    for_each = each.value.target_configuration != null ? [each.value.target_configuration] : []
    content {
      dynamic "mcp" {
        for_each = target_configuration.value.mcp != null ? [target_configuration.value.mcp] : []
        content {
          dynamic "lambda" {
            for_each = mcp.value.lambda != null ? [mcp.value.lambda] : []
            content {
              lambda_arn = lambda.value.lambda_arn
            }
          }
          dynamic "mcp_server" {
            for_each = mcp.value.mcp_server != null ? [mcp.value.mcp_server] : []
            content {
              endpoint = mcp_server.value.endpoint
            }
          }
        }
      }
    }
  }
}

resource "aws_bedrockagentcore_browser" "this" {
  count = var.create_browser ? 1 : 0

  name               = var.browser_name
  description        = var.browser_description
  execution_role_arn = var.browser_execution_role_arn

  dynamic "network_configuration" {
    for_each = var.browser_vpc_config != null ? [var.browser_vpc_config] : []
    content {
      network_mode = network_configuration.value.network_mode
      dynamic "vpc_config" {
        for_each = network_configuration.value.vpc_config != null ? [network_configuration.value.vpc_config] : []
        content {
          security_groups = vpc_config.value.security_groups
          subnets         = vpc_config.value.subnets
        }
      }
    }
  }

  dynamic "recording" {
    for_each = var.browser_recording_config != null ? [var.browser_recording_config] : []
    content {
      enabled = recording.value.enabled
      dynamic "s3_location" {
        for_each = recording.value.s3_location != null ? [recording.value.s3_location] : []
        content {
          bucket = s3_location.value.bucket
          prefix = s3_location.value.prefix
        }
      }
    }
  }

  tags = var.tags
}
