# aws/workload_component/step_functions_lambda

Composed workload module for Step Functions + Lambda orchestration.

## Features

- Creates a Step Functions State Machine using the opinionated base module.
- Automatically creates an IAM role with least-privilege permissions to invoke specified Lambdas.
- Configures mandatory CloudWatch logging with CMK encryption and X-Ray tracing.
- Enforces organization-standard tagging.

## Usage

```hcl
module "orchestration" {
  source = "./aws/workload_component/step_functions_lambda"

  name        = "process-order"
  kms_key_arn = module.kms.key_arn
  lambda_arns = [
    module.validate_order.function_arn,
    module.charge_card.function_arn
  ]

  definition = jsonencode({
    StartAt = "ValidateOrder"
    States = {
      ValidateOrder = {
        Type = "Task"
        Resource = module.validate_order.function_arn
        Next = "ChargeCard"
      }
      ChargeCard = {
        Type = "Task"
        Resource = module.charge_card.function_arn
        End = true
      }
    }
  })

  tags = {
    environment = "prod"
    owner       = "ecommerce-team"
    project     = "order-processing"
    cost_center = "CC-9999"
  }
}
```

## Security

- The state machine role is scoped to only `lambda:InvokeFunction` on the provided `lambda_arns`.
- CloudWatch logs are encrypted using the provided `kms_key_arn`.
- X-Ray tracing is enabled by default.
