resource "aws_observabilityadmin_telemetry_rule" "this" {
  count     = var.is_organization_rule ? 0 : 1
  rule_name = var.rule_name

  rule {
    telemetry_type         = var.telemetry_type
    resource_type          = var.resource_type
    selection_criteria     = var.selection_criteria
    telemetry_source_types = var.telemetry_source_types
    scope                  = var.scope
    all_regions            = var.all_regions
    regions                = var.regions
    allow_field_updates    = var.allow_field_updates

    dynamic "destination_configuration" {
      for_each = var.destination_configurations
      content {
        destination_type    = destination_configuration.value.destination_type
        destination_pattern = destination_configuration.value.destination_pattern
        retention_in_days   = destination_configuration.value.retention_in_days

        dynamic "cloudtrail_parameters" {
          for_each = destination_configuration.value.cloudtrail_parameters != null ? [destination_configuration.value.cloudtrail_parameters] : []
          content {
            dynamic "advanced_event_selectors" {
              for_each = cloudtrail_parameters.value.advanced_event_selectors != null ? cloudtrail_parameters.value.advanced_event_selectors : []
              content {
                name = advanced_event_selectors.value.name
                dynamic "field_selectors" {
                  for_each = advanced_event_selectors.value.field_selectors != null ? advanced_event_selectors.value.field_selectors : []
                  content {
                    field           = field_selectors.value.field
                    equals          = field_selectors.value.equals
                    not_equals      = field_selectors.value.not_equals
                    starts_with     = field_selectors.value.starts_with
                    not_starts_with = field_selectors.value.not_starts_with
                    ends_with       = field_selectors.value.ends_with
                    not_ends_with   = field_selectors.value.not_ends_with
                  }
                }
              }
            }
          }
        }

        dynamic "elb_load_balancer_logging_parameters" {
          for_each = destination_configuration.value.elb_load_balancer_logging_parameters != null ? [destination_configuration.value.elb_load_balancer_logging_parameters] : []
          content {
            field_delimiter = elb_load_balancer_logging_parameters.value.field_delimiter
            output_format   = elb_load_balancer_logging_parameters.value.output_format
          }
        }

        dynamic "log_delivery_parameters" {
          for_each = destination_configuration.value.log_delivery_parameters != null ? [destination_configuration.value.log_delivery_parameters] : []
          content {
            log_types = log_delivery_parameters.value.log_types
          }
        }

        dynamic "msk_monitoring_parameters" {
          for_each = destination_configuration.value.msk_monitoring_parameters != null ? [destination_configuration.value.msk_monitoring_parameters] : []
          content {
            enhanced_monitoring = msk_monitoring_parameters.value.enhanced_monitoring
          }
        }

        dynamic "vpc_flow_log_parameters" {
          for_each = destination_configuration.value.vpc_flow_log_parameters != null ? [destination_configuration.value.vpc_flow_log_parameters] : []
          content {
            log_format               = vpc_flow_log_parameters.value.log_format
            max_aggregation_interval = vpc_flow_log_parameters.value.max_aggregation_interval
            traffic_type             = vpc_flow_log_parameters.value.traffic_type
          }
        }

        dynamic "waf_logging_parameters" {
          for_each = destination_configuration.value.waf_logging_parameters != null ? [destination_configuration.value.waf_logging_parameters] : []
          content {
            log_type = waf_logging_parameters.value.log_type

            dynamic "logging_filter" {
              for_each = waf_logging_parameters.value.logging_filter != null ? [waf_logging_parameters.value.logging_filter] : []
              content {
                default_behavior = logging_filter.value.default_behavior

                dynamic "filters" {
                  for_each = logging_filter.value.filters != null ? logging_filter.value.filters : []
                  content {
                    behavior    = filters.value.behavior
                    requirement = filters.value.requirement

                    dynamic "conditions" {
                      for_each = filters.value.conditions != null ? filters.value.conditions : []
                      content {
                        dynamic "action_condition" {
                          for_each = conditions.value.action_condition != null ? [conditions.value.action_condition] : []
                          content {
                            action = action_condition.value.action
                          }
                        }

                        dynamic "label_name_condition" {
                          for_each = conditions.value.label_name_condition != null ? [conditions.value.label_name_condition] : []
                          content {
                            label_name = label_name_condition.value.label_name
                          }
                        }
                      }
                    }
                  }
                }
              }
            }

            dynamic "redacted_fields" {
              for_each = waf_logging_parameters.value.redacted_fields != null ? [waf_logging_parameters.value.redacted_fields] : []
              content {
                method       = redacted_fields.value.method
                query_string = redacted_fields.value.query_string
                uri_path     = redacted_fields.value.uri_path

                dynamic "single_header" {
                  for_each = redacted_fields.value.single_header != null ? [redacted_fields.value.single_header] : []
                  content {
                    name = single_header.value.name
                  }
                }
              }
            }
          }
        }
      }
    }
  }

  tags = var.tags
}

resource "aws_observabilityadmin_telemetry_rule_for_organization" "this" {
  count     = var.is_organization_rule ? 1 : 0
  rule_name = var.rule_name

  rule {
    telemetry_type         = var.telemetry_type
    resource_type          = var.resource_type
    selection_criteria     = var.selection_criteria
    telemetry_source_types = var.telemetry_source_types
    scope                  = var.scope
    all_regions            = var.all_regions
    regions                = var.regions
    allow_field_updates    = var.allow_field_updates

    dynamic "destination_configuration" {
      for_each = var.destination_configurations
      content {
        destination_type    = destination_configuration.value.destination_type
        destination_pattern = destination_configuration.value.destination_pattern
        retention_in_days   = destination_configuration.value.retention_in_days

        dynamic "cloudtrail_parameters" {
          for_each = destination_configuration.value.cloudtrail_parameters != null ? [destination_configuration.value.cloudtrail_parameters] : []
          content {
            dynamic "advanced_event_selectors" {
              for_each = cloudtrail_parameters.value.advanced_event_selectors != null ? cloudtrail_parameters.value.advanced_event_selectors : []
              content {
                name = advanced_event_selectors.value.name
                dynamic "field_selectors" {
                  for_each = advanced_event_selectors.value.field_selectors != null ? advanced_event_selectors.value.field_selectors : []
                  content {
                    field           = field_selectors.value.field
                    equals          = field_selectors.value.equals
                    not_equals      = field_selectors.value.not_equals
                    starts_with     = field_selectors.value.starts_with
                    not_starts_with = field_selectors.value.not_starts_with
                    ends_with       = field_selectors.value.ends_with
                    not_ends_with   = field_selectors.value.not_ends_with
                  }
                }
              }
            }
          }
        }

        dynamic "elb_load_balancer_logging_parameters" {
          for_each = destination_configuration.value.elb_load_balancer_logging_parameters != null ? [destination_configuration.value.elb_load_balancer_logging_parameters] : []
          content {
            field_delimiter = elb_load_balancer_logging_parameters.value.field_delimiter
            output_format   = elb_load_balancer_logging_parameters.value.output_format
          }
        }

        dynamic "log_delivery_parameters" {
          for_each = destination_configuration.value.log_delivery_parameters != null ? [destination_configuration.value.log_delivery_parameters] : []
          content {
            log_types = log_delivery_parameters.value.log_types
          }
        }

        dynamic "msk_monitoring_parameters" {
          for_each = destination_configuration.value.msk_monitoring_parameters != null ? [destination_configuration.value.msk_monitoring_parameters] : []
          content {
            enhanced_monitoring = msk_monitoring_parameters.value.enhanced_monitoring
          }
        }

        dynamic "vpc_flow_log_parameters" {
          for_each = destination_configuration.value.vpc_flow_log_parameters != null ? [destination_configuration.value.vpc_flow_log_parameters] : []
          content {
            log_format               = vpc_flow_log_parameters.value.log_format
            max_aggregation_interval = vpc_flow_log_parameters.value.max_aggregation_interval
            traffic_type             = vpc_flow_log_parameters.value.traffic_type
          }
        }

        dynamic "waf_logging_parameters" {
          for_each = destination_configuration.value.waf_logging_parameters != null ? [destination_configuration.value.waf_logging_parameters] : []
          content {
            log_type = waf_logging_parameters.value.log_type

            dynamic "logging_filter" {
              for_each = waf_logging_parameters.value.logging_filter != null ? [waf_logging_parameters.value.logging_filter] : []
              content {
                default_behavior = logging_filter.value.default_behavior

                dynamic "filters" {
                  for_each = logging_filter.value.filters != null ? logging_filter.value.filters : []
                  content {
                    behavior    = filters.value.behavior
                    requirement = filters.value.requirement

                    dynamic "conditions" {
                      for_each = filters.value.conditions != null ? filters.value.conditions : []
                      content {
                        dynamic "action_condition" {
                          for_each = conditions.value.action_condition != null ? [conditions.value.action_condition] : []
                          content {
                            action = action_condition.value.action
                          }
                        }

                        dynamic "label_name_condition" {
                          for_each = conditions.value.label_name_condition != null ? [conditions.value.label_name_condition] : []
                          content {
                            label_name = label_name_condition.value.label_name
                          }
                        }
                      }
                    }
                  }
                }
              }
            }

            dynamic "redacted_fields" {
              for_each = waf_logging_parameters.value.redacted_fields != null ? [waf_logging_parameters.value.redacted_fields] : []
              content {
                method       = redacted_fields.value.method
                query_string = redacted_fields.value.query_string
                uri_path     = redacted_fields.value.uri_path

                dynamic "single_header" {
                  for_each = redacted_fields.value.single_header != null ? [redacted_fields.value.single_header] : []
                  content {
                    name = single_header.value.name
                  }
                }
              }
            }
          }
        }
      }
    }
  }

  tags = var.tags
}
