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

resource "aws_bedrockagentcore_online_evaluation_config" "this" {
  for_each = var.online_evaluation_configs

  online_evaluation_config_name = each.key
  description                   = each.value.description
  kms_key_arn                   = var.kms_key_arn
  evaluation_execution_role_arn = each.value.evaluation_execution_role_arn
  enable_on_create              = each.value.enable_on_create

  data_source_config {
    cloudwatch_logs {
      log_group_names = each.value.data_source_config.cloudwatch_logs.log_group_names
      service_names   = each.value.data_source_config.cloudwatch_logs.service_names
    }
  }

  dynamic "evaluator" {
    for_each = each.value.evaluator_ids
    content {
      evaluator_id = evaluator.value
    }
  }

  dynamic "rule" {
    for_each = each.value.sampling_percentage != null ? [1] : []
    content {
      sampling_config {
        sampling_percentage = each.value.sampling_percentage
      }
    }
  }

  tags = var.tags
}

resource "aws_bedrockagentcore_browser" "this" {
  for_each = var.browsers

  name               = each.key
  description        = each.value.description
  kms_key_arn        = var.kms_key_arn
  execution_role_arn = each.value.execution_role_arn

  network_configuration {
    network_mode = each.value.network_configuration.network_mode
    vpc_config {
      security_groups = each.value.network_configuration.vpc_config.security_groups
      subnets         = each.value.network_configuration.vpc_config.subnets
    }
  }

  dynamic "recording" {
    for_each = each.value.recording != null ? [each.value.recording] : []
    content {
      enabled = recording.value.enabled
      s3_location {
        bucket = recording.value.s3_location.bucket
        prefix = recording.value.s3_location.prefix
      }
    }
  }

  tags = var.tags
}

resource "aws_bedrockagentcore_gateway_target" "this" {
  for_each = var.gateway_targets

  name               = each.key
  description        = each.value.description
  gateway_identifier = aws_bedrockagentcore_gateway.this.gateway_id

  target_configuration {
    mcp {
      dynamic "lambda" {
        for_each = each.value.target_configuration.mcp.lambda != null ? [each.value.target_configuration.mcp.lambda] : []
        content {
          lambda_arn = lambda.value.lambda_arn
        }
      }
    }
  }
}
