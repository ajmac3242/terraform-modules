# aws/base_component/cloudwatch_alarm

Opinionated CloudWatch Metric Alarm module.

## Features

- CloudWatch Metric Alarm
- Tags validation

## Usage

```hcl
module "alarm" {
  source = "./aws/base_component/cloudwatch_alarm"

  alarm_name          = "cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "This metric monitors ec2 cpu utilization"

  dimensions = {
    InstanceId = "i-12345678"
  }

  tags = {
    environment = "prod"
    owner       = "platform-team"
    project     = "my-app"
    cost_center = "CC-1234"
  }
}
```
