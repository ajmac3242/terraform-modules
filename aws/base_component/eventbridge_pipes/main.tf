# Main resource definitions for EventBridge Pipes

module "iam_role" {
  source = "../iam"

  role_name   = "${var.name}-pipe-role"
  description = "IAM role for EventBridge Pipe ${var.name}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "pipes.amazonaws.com"
        }
      }
    ]
  })

  managed_policy_arns = var.custom_policy_arns

  tags = var.tags
}

resource "aws_pipes_pipe" "this" {
  name        = var.name
  description = var.description
  role_arn    = module.iam_role.role_arn
  source      = var.source_arn
  target      = var.target_arn
  enrichment  = var.enrichment_arn

  desired_state = var.desired_state

  dynamic "source_parameters" {
    for_each = length(var.source_parameters) > 0 ? [var.source_parameters] : []
    content {
      dynamic "filter_criteria" {
        for_each = lookup(source_parameters.value, "filter_criteria", null) != null ? [source_parameters.value.filter_criteria] : []
        content {
          dynamic "filter" {
            for_each = lookup(filter_criteria.value, "filter", [])
            content {
              pattern = filter.value.pattern
            }
          }
        }
      }

      dynamic "kinesis_stream_parameters" {
        for_each = lookup(source_parameters.value, "kinesis_stream_parameters", null) != null ? [source_parameters.value.kinesis_stream_parameters] : []
        content {
          batch_size                         = lookup(kinesis_stream_parameters.value, "batch_size", null)
          maximum_batching_window_in_seconds = lookup(kinesis_stream_parameters.value, "maximum_batching_window_in_seconds", null)
          starting_position                  = kinesis_stream_parameters.value.starting_position
        }
      }

      dynamic "sqs_queue_parameters" {
        for_each = lookup(source_parameters.value, "sqs_queue_parameters", null) != null ? [source_parameters.value.sqs_queue_parameters] : []
        content {
          batch_size                         = lookup(sqs_queue_parameters.value, "batch_size", null)
          maximum_batching_window_in_seconds = lookup(sqs_queue_parameters.value, "maximum_batching_window_in_seconds", null)
        }
      }

      dynamic "dynamodb_stream_parameters" {
        for_each = lookup(source_parameters.value, "dynamodb_stream_parameters", null) != null ? [source_parameters.value.dynamodb_stream_parameters] : []
        content {
          batch_size                         = lookup(dynamodb_stream_parameters.value, "batch_size", null)
          maximum_batching_window_in_seconds = lookup(dynamodb_stream_parameters.value, "maximum_batching_window_in_seconds", null)
          starting_position                  = dynamodb_stream_parameters.value.starting_position
        }
      }
    }
  }

  dynamic "target_parameters" {
    for_each = length(var.target_parameters) > 0 ? [var.target_parameters] : []
    content {
      dynamic "lambda_function_parameters" {
        for_each = lookup(target_parameters.value, "lambda_function_parameters", null) != null ? [target_parameters.value.lambda_function_parameters] : []
        content {
          invocation_type = lookup(lambda_function_parameters.value, "invocation_type", null)
        }
      }

      dynamic "step_function_state_machine_parameters" {
        for_each = lookup(target_parameters.value, "step_function_state_machine_parameters", null) != null ? [target_parameters.value.step_function_state_machine_parameters] : []
        content {
          invocation_type = lookup(step_function_state_machine_parameters.value, "invocation_type", null)
        }
      }

      dynamic "eventbridge_event_bus_parameters" {
        for_each = lookup(target_parameters.value, "eventbridge_event_bus_parameters", null) != null ? [target_parameters.value.eventbridge_event_bus_parameters] : []
        content {
          endpoint_id = lookup(eventbridge_event_bus_parameters.value, "endpoint_id", null)
          resources   = lookup(eventbridge_event_bus_parameters.value, "resources", null)
          source      = lookup(eventbridge_event_bus_parameters.value, "source", null)
          time        = lookup(eventbridge_event_bus_parameters.value, "time", null)
          detail_type = lookup(eventbridge_event_bus_parameters.value, "detail_type", null)
        }
      }

      dynamic "sqs_queue_parameters" {
        for_each = lookup(target_parameters.value, "sqs_queue_parameters", null) != null ? [target_parameters.value.sqs_queue_parameters] : []
        content {
          message_group_id = lookup(sqs_queue_parameters.value, "message_group_id", null)
        }
      }
    }
  }

  dynamic "enrichment_parameters" {
    for_each = length(var.enrichment_parameters) > 0 ? [var.enrichment_parameters] : []
    content {
      input_template = lookup(enrichment_parameters.value, "input_template", null)

      dynamic "http_parameters" {
        for_each = lookup(enrichment_parameters.value, "http_parameters", null) != null ? [enrichment_parameters.value.http_parameters] : []
        content {
          path_parameter_values   = lookup(http_parameters.value, "path_parameter_values", null)
          query_string_parameters = lookup(http_parameters.value, "query_string_parameters", null)
          header_parameters       = lookup(http_parameters.value, "header_parameters", null)
        }
      }
    }
  }

  tags = var.tags
}
