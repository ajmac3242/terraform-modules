# aws/workload_component/eventbridge_lambda

EventBridge rule + Lambda pattern.

## Features

- Composes `aws/base_component/lambda` and `aws/base_component/eventbridge`
- Supports Event Pattern or Scheduled rules
- Automatic Lambda invocation permission
- Optional SQS Dead Letter Queue (DLQ) with CMK encryption
- Tags validation

## Usage

### Scheduled Job (Cron)

```hcl
module "nightly_job" {
  source = "./aws/workload_component/eventbridge_lambda"

  name                = "nightly-cleanup"
  description         = "Runs nightly cleanup task"
  schedule_expression = "cron(0 2 * * ? *)"

  lambda_function_name = "cleanup-function"
  lambda_handler       = "index.handler"
  lambda_runtime       = "nodejs18.x"
  lambda_source_path   = "path/to/source.zip"

  tags = {
    environment = "prod"
    owner       = "platform-team"
    project     = "maintenance"
    cost_center = "CC-1234"
  }
}
```

### Event Pattern Trigger with DLQ

```hcl
module "event_trigger" {
  source = "./aws/workload_component/eventbridge_lambda"

  name          = "order-processor"
  event_pattern = jsonencode({
    source      = ["my.orders"]
    detail-type = ["OrderCreated"]
  })

  enable_dlq = true

  lambda_function_name = "order-processor"
  lambda_handler       = "app.lambda_handler"
  lambda_runtime       = "python3.11"
  lambda_source_path   = "path/to/source.zip"

  tags = {
    environment = "prod"
    owner       = "ecommerce-team"
    project     = "order-system"
    cost_center = "CC-5678"
  }
}
```
