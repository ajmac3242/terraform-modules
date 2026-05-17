# Standardized Lambda with Powertools

## Purpose
Standardizes serverless observability (logging, metrics, tracing) by composing the base Lambda module with AWS Lambda Powertools integration.

## Usage
```hcl
module "lambda_powertools" {
  source = "./aws/workload_component/lambda_powertools"

  function_name        = "my-observable-function"
  filename             = "lambda.zip"
  service_name         = "user-service"
  powertools_layer_arn = "arn:aws:lambda:us-east-1:017000801446:layer:AWSLambdaPowertoolsPythonV2:60"

  tags = {
    environment = "prod"
    owner       = "app-team"
    project     = "observability"
    cost_center = "1234"
  }
}
```

## Security
- Inherits security defaults from the base Lambda module (CMK encryption, X-Ray tracing).
- Mandatory CMK encryption for CloudWatch Logs.
- Least-privilege IAM execution role.

## Variables
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| function_name | The name of the Lambda function | string | n/a | yes |
| filename | Path to deployment package | string | n/a | yes |
| service_name | Service name for Powertools | string | n/a | yes |
| powertools_layer_arn | ARN of the Powertools layer | string | n/a | yes |
| log_level | Log level for Powertools | string | INFO | no |
| runtime | Lambda runtime | string | python3.11 | no |
| handler | Lambda handler | string | index.handler | no |
| kms_key_arn | ARN of the KMS key | string | null | no |
| vpc_config | VPC configuration | object | null | no |
| tags | Resource tags | map(string) | n/a | yes |

## Outputs
| Name | Description |
|------|-------------|
| function_arn | The ARN of the Lambda function |
| function_name | The name of the Lambda function |
| role_arn | The ARN of the execution role |
| log_group_name | The name of the Log Group |
| tags | Tags assigned to the resource |
