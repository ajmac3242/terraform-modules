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
