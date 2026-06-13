# S3 Bucket using base module
module "s3" {
  source = "../../base_component/s3"

  bucket_name   = var.bucket_name
  log_bucket_id = var.log_bucket_id

  tags = var.tags
}

# Lambda Function using base module
module "lambda" {
  source = "../../base_component/lambda"

  function_name = var.lambda_function_name
  description   = var.lambda_description
  handler       = var.lambda_handler
  runtime       = var.lambda_runtime
  filename      = var.lambda_source_path

  vpc_config = var.lambda_vpc_config

  tags = var.tags
}

# Lambda Permission for S3 to invoke
resource "aws_lambda_permission" "allow_s3" {
  statement_id  = "AllowExecutionFromS3Bucket-${var.bucket_name}"
  action        = "lambda:InvokeFunction"
  function_name = module.lambda.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = module.s3.bucket_arn
}

# S3 Bucket Notification
resource "aws_s3_bucket_notification" "this" {
  bucket = module.s3.bucket_id

  lambda_function {
    lambda_function_arn = module.lambda.function_arn
    events              = var.events
    filter_prefix       = var.filter_prefix
    filter_suffix       = var.filter_suffix
  }

  depends_on = [aws_lambda_permission.allow_s3]
}
