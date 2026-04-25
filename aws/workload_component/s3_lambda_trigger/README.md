# aws/workload_component/s3_lambda_trigger

S3 event notification + Lambda pattern.

## Features

- Composes `aws/base_component/s3` and `aws/base_component/lambda`
- Configurable bucket event types and object prefix/suffix filters
- Automatic Lambda invocation permission from S3
- Secure S3 defaults (CMK encryption, public access block, TLS-only)
- Tags validation

## Usage

### Object Created Trigger

```hcl
module "s3_trigger" {
  source = "./aws/workload_component/s3_lambda_trigger"

  bucket_name   = "my-processing-bucket"
  log_bucket_id = "my-logging-bucket"

  lambda_function_name = "process-upload"
  lambda_description   = "Processes files uploaded to S3"
  lambda_handler       = "index.handler"
  lambda_runtime       = "nodejs18.x"
  lambda_source_path   = "path/to/source.zip"

  filter_prefix = "uploads/"
  filter_suffix = ".json"

  tags = {
    environment = "prod"
    owner       = "data-team"
    project     = "ingestion"
    cost_center = "CC-1234"
  }
}
```
