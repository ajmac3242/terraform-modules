# aws/base_component/eventbridge

## Purpose
Opinionated EventBridge module. Foundational event-routing module that supports rule creation and target attachment with security-by-default.

## Usage
```hcl
module "eventbridge" {
  source = "./aws/base_component/eventbridge"

  name          = "my-event-bus"
  event_bus_name = "custom-bus"

  tags = {
    environment = "prod"
    owner       = "platform-team"
    project     = "standardization"
    cost_center = "12345"
  }
}
```

## Security
- **Encryption**: Event buses are encrypted using a Customer Managed Key (CMK) by default.
- **Access**: Least-privilege IAM policies are enforced for all targets.

## Variables
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `name` | Name of the EventBridge rule | `string` | n/a | yes |
| `event_bus_name` | Name of the event bus. If null, the default bus is used. | `string` | `null` | no |
| `event_pattern` | Event pattern for the rule | `string` | `null` | no |
| `schedule_expression` | Schedule expression for the rule | `string` | `null` | no |
| `kms_key_arn` | ARN of the KMS key for event bus encryption. If null, a new key is created. | `string` | `null` | no |
| `tags` | Standard tags for all resources | `map(string)` | n/a | yes |

## Outputs
| Name | Description |
|------|-------------|
| `event_bus_arn` | The ARN of the EventBridge bus |
| `event_bus_name` | The name of the EventBridge bus |
| `rule_arn` | The ARN of the EventBridge rule |
| `kms_key_arn` | The ARN of the KMS key used for encryption |
| `tags` | A map of tags assigned to the resource |
