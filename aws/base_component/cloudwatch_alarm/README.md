# aws/base_component/cloudwatch_alarm

## Purpose
Opinionated CloudWatch alarms module. Reusable observability primitive for consistent alarms across workload modules. Enables safer production defaults and easier composition.

## Usage
```hcl
module "lambda_alarms" {
  source = "./aws/base_component/cloudwatch_alarm"

  alarms = {
    "high-error-rate" = {
      comparison_operator = "GreaterThanThreshold"
      evaluation_periods  = 1
      metric_name         = "Errors"
      namespace           = "AWS/Lambda"
      period              = 60
      statistic           = "Sum"
      threshold           = 1
      dimensions = {
        FunctionName = "my-function"
      }
    }
  }

  tags = {
    environment = "prod"
    owner       = "platform-team"
    project     = "standardization"
    cost_center = "12345"
  }
}
```

## Security
- **Visibility**: Alarms provide visibility into service health and potential security incidents (e.g., high error rates, unauthorized access attempts).
- **Encryption**: CloudWatch Logs integration (if used) is encrypted via CMK.

## Variables
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `alarms` | Map of alarm configurations | `any` | n/a | yes |
| `alarm_actions` | List of ARNs to notify when alarm transitions to ALARM state | `list(string)` | `[]` | no |
| `ok_actions` | List of ARNs to notify when alarm transitions to OK state | `list(string)` | `[]` | no |
| `tags` | Standard tags for all resources | `map(string)` | n/a | yes |

## Outputs
| Name | Description |
|------|-------------|
| `alarm_arns` | Map of alarm ARNs |
| `alarm_names` | List of alarm names |
