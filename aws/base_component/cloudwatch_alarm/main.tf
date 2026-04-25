# Main CloudWatch Metric Alarm resources
resource "aws_cloudwatch_metric_alarm" "this" {
  for_each = var.alarms

  alarm_name          = each.key
  comparison_operator = each.value.comparison_operator
  evaluation_periods  = each.value.evaluation_periods
  metric_name         = each.value.metric_name
  namespace           = each.value.namespace
  period              = each.value.period
  statistic           = each.value.statistic
  threshold           = each.value.threshold
  unit                = each.value.unit

  alarm_description = each.value.alarm_description
  alarm_actions     = each.value.alarm_actions
  ok_actions        = each.value.ok_actions

  dimensions = each.value.dimensions

  tags = var.tags
}
