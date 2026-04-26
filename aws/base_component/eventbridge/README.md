# aws/base_component/eventbridge

Opinionated EventBridge module.

## Features

- EventBridge Bus creation (optional)
- Mandatory KMS encryption with CMK for the event bus (auto-created or provided)
- EventBridge Rule creation (event pattern or schedule)
- EventBridge Target attachment
- Dead-letter queue support for targets
- Tags validation

## Usage

### Custom Bus with a Rule and Target

```hcl
module "eventbridge" {
  source = "./aws/base_component/eventbridge"

  name = "my-bus"

  rules = {
    "my-rule" = {
      description   = "My event pattern rule"
      event_pattern = jsonencode({
        source = ["my.app"]
      })
    }
  }

  targets = {
    "my-rule/my-target" = {
      rule_name = "my-rule"
      arn       = "arn:aws:lambda:us-east-1:123456789012:function:my-function"
    }
  }

  # KMS configuration (Optional)
  # existing_kms_key_arn = "arn:aws:kms:us-east-1:123456789012:key/..."

  tags = {
    environment = "prod"
    owner       = "platform-team"
    project     = "my-app"
    cost_center = "CC-1234"
  }
}
```

### Scheduled Rule on Default Bus

```hcl
module "eventbridge" {
  source = "./aws/base_component/eventbridge"

  create_bus = false

  rules = {
    "nightly-job" = {
      description         = "Run nightly at 2 AM"
      schedule_expression = "cron(0 2 * * ? *)"
    }
  }

  targets = {
    "nightly-job/lambda-target" = {
      rule_name = "nightly-job"
      arn       = "arn:aws:lambda:us-east-1:123456789012:function:nightly-task"
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
