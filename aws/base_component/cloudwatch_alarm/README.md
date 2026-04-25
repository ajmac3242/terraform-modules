# aws/base_component/cloudwatch_alarm

Opinionated CloudWatch Alarm module.

## Features

- Support for one or more CloudWatch metric alarms
- Configurable dimensions, statistics, and thresholds
- Support for alarm and OK actions
- Tags validation

## Usage

### Single Lambda Error Alarm

```hcl
module "lambda_alarm" {
  source = "./aws/base_component/cloudwatch_alarm"

  alarms = {
    "my-function-errors" = {
      comparison_operator = "GreaterThanThreshold"
      evaluation_periods  = 1
      metric_name         = "Errors"
      namespace           = "AWS/Lambda"
      period              = 60
      statistic           = "Sum"
      threshold           = 0
      alarm_description   = "Alarm if function has errors"
      alarm_actions       = ["arn:aws:sns:us-east-1:123456789012:my-topic"]
      dimensions = {
        FunctionName = "my-function"
      }
    }
  }

  tags = {
    environment = "prod"
    owner       = "platform-team"
    project     = "my-app"
    cost_center = "CC-1234"
  }
}
```

### Multiple ECS Alarms

```hcl
module "ecs_alarms" {
  source = "./aws/base_component/cloudwatch_alarm"

  alarms = {
    "cpu-high" = {
      comparison_operator = "GreaterThanThreshold"
      evaluation_periods  = 2
      metric_name         = "CPUUtilization"
      namespace           = "AWS/ECS"
      period              = 300
      statistic           = "Average"
      threshold           = 80
      dimensions = {
        ClusterName = "my-cluster"
        ServiceName = "my-service"
      }
    },
    "memory-high" = {
      comparison_operator = "GreaterThanThreshold"
      evaluation_periods  = 2
      metric_name         = "MemoryUtilization"
      namespace           = "AWS/ECS"
      period              = 300
      statistic           = "Average"
      threshold           = 80
      dimensions = {
        ClusterName = "my-cluster"
        ServiceName = "my-service"
      }
    }
  }

  tags = {
    environment = "prod"
    owner       = "platform-team"
    project     = "my-app"
    cost_center = "CC-1234"
  }
}
```
