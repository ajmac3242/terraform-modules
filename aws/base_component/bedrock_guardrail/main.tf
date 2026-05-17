# aws_bedrock_guardrail
resource "aws_bedrock_guardrail" "this" {
  name                      = var.name
  description               = var.description
  blocked_input_messaging   = var.blocked_input_messaging
  blocked_outputs_messaging = var.blocked_outputs_messaging
  kms_key_arn               = var.kms_key_arn

  dynamic "content_policy_config" {
    for_each = var.content_policy_config != null ? [var.content_policy_config] : []
    content {
      dynamic "filters_config" {
        for_each = content_policy_config.value.filters_config
        content {
          type            = filters_config.value.type
          input_strength  = filters_config.value.input_strength
          output_strength = filters_config.value.output_strength
        }
      }
    }
  }

  dynamic "topic_policy_config" {
    for_each = var.topic_policy_config != null ? [var.topic_policy_config] : []
    content {
      dynamic "topics_config" {
        for_each = topic_policy_config.value.topics_config
        content {
          name       = topics_config.value.name
          definition = topics_config.value.definition
          examples   = topics_config.value.examples
          type       = topics_config.value.type
        }
      }
    }
  }

  dynamic "word_policy_config" {
    for_each = var.word_policy_config != null ? [var.word_policy_config] : []
    content {
      dynamic "managed_word_lists_config" {
        for_each = word_policy_config.value.managed_word_lists_config
        content {
          type = managed_word_lists_config.value.type
        }
      }
      dynamic "words_config" {
        for_each = word_policy_config.value.words_config
        content {
          text = words_config.value.text
        }
      }
    }
  }

  dynamic "sensitive_information_policy_config" {
    for_each = var.sensitive_information_policy_config != null ? [var.sensitive_information_policy_config] : []
    content {
      dynamic "pii_entities_config" {
        for_each = sensitive_information_policy_config.value.pii_entities_config
        content {
          type   = pii_entities_config.value.type
          action = pii_entities_config.value.action
        }
      }
      dynamic "regexes_config" {
        for_each = sensitive_information_policy_config.value.regexes_config
        content {
          name        = regexes_config.value.name
          description = regexes_config.value.description
          pattern     = regexes_config.value.pattern
          action      = regexes_config.value.action
        }
      }
    }
  }

  dynamic "contextual_grounding_policy_config" {
    for_each = var.contextual_grounding_policy_config != null ? [var.contextual_grounding_policy_config] : []
    content {
      dynamic "filters_config" {
        for_each = contextual_grounding_policy_config.value.filters_config
        content {
          type      = filters_config.value.type
          threshold = filters_config.value.threshold
        }
      }
    }
  }

  tags = var.tags
}

# aws_bedrock_guardrail_version
resource "aws_bedrock_guardrail_version" "this" {
  description   = "Immutable version of ${var.name}"
  guardrail_arn = aws_bedrock_guardrail.this.guardrail_arn
}
