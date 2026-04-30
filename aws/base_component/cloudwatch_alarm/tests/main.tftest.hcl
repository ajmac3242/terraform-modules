variables {
  alarms = {
    "test-alarm" = {
      comparison_operator = "GreaterThanThreshold"
      evaluation_periods  = 1
      metric_name         = "CPUUtilization"
      namespace           = "AWS/EC2"
      period              = 60
      statistic           = "Average"
      threshold           = 80
      dimensions = {
        InstanceId = "i-1234567890abcdef0"
      }
    }
  }
  tags = {
    environment = "test"
    owner       = "test-owner"
    project     = "test-project"
    cost_center = "test-cc"
  }
}

provider "aws" {
  region                      = "us-east-1"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true
  access_key                  = "mock_access_key"
  secret_key                  = "mock_secret_key"
}

run "valid_alarm_creation" {
  command = plan

  assert {
    condition     = length(aws_cloudwatch_metric_alarm.this) == 1
    error_message = "Alarm should be created"
  }

  assert {
    condition     = aws_cloudwatch_metric_alarm.this["test-alarm"].metric_name == "CPUUtilization"
    error_message = "Metric name does not match"
  }

  assert {
    condition     = aws_cloudwatch_metric_alarm.this["test-alarm"].tags["environment"] == "test" && aws_cloudwatch_metric_alarm.this["test-alarm"].tags["owner"] == "test-owner" && aws_cloudwatch_metric_alarm.this["test-alarm"].tags["project"] == "test-project" && aws_cloudwatch_metric_alarm.this["test-alarm"].tags["cost_center"] == "test-cc"
    error_message = "Mandatory tags are missing or incorrect on CloudWatch alarm."
  }
}

run "multiple_alarms_creation" {
  command = plan

  variables {
    alarms = {
      "alarm-1" = {
        comparison_operator = "GreaterThanThreshold"
        evaluation_periods  = 1
        metric_name         = "Errors"
        namespace           = "AWS/Lambda"
        period              = 60
        statistic           = "Sum"
        threshold           = 0
      },
      "alarm-2" = {
        comparison_operator = "LessThanThreshold"
        evaluation_periods  = 1
        metric_name         = "Invocations"
        namespace           = "AWS/Lambda"
        period              = 3600
        statistic           = "Sum"
        threshold           = 1
      }
    }
  }

  assert {
    condition     = length(aws_cloudwatch_metric_alarm.this) == 2
    error_message = "Two alarms should be created"
  }
}
