# Centralized Log Storage using the base S3 module
module "log_storage" {
  source = "../../base_component/s3"

  bucket_name                = "${var.name_prefix}-centralized-logs"
  enable_access_logging      = false # Circular logging not desired for the logging bucket itself
  aws_account_id             = var.aws_account_id
  additional_policy_document = data.aws_iam_policy_document.log_delivery.json

  tags = var.tags
}

data "aws_iam_policy_document" "log_delivery" {
  # ALB Log Delivery
  statement {
    sid       = "AllowALBLogDelivery"
    effect    = "Allow"
    actions   = ["s3:PutObject"]
    resources = ["arn:aws:s3:::${var.name_prefix}-centralized-logs/alb/*"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.alb_account_id}:root"]
    }
  }

  # VPC Flow Logs Delivery
  statement {
    sid    = "AllowVPCFlowLogsDelivery"
    effect = "Allow"
    actions = [
      "s3:PutObject",
      "s3:GetBucketAcl"
    ]
    resources = [
      "arn:aws:s3:::${var.name_prefix}-centralized-logs",
      "arn:aws:s3:::${var.name_prefix}-centralized-logs/*"
    ]

    principals {
      type        = "Service"
      identifiers = [var.vpc_flow_logs_service_principal]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [var.aws_account_id]
    }
  }

  # CloudFront OAC Access (for logs)
  statement {
    sid       = "AllowCloudFrontLogDelivery"
    effect    = "Allow"
    actions   = ["s3:PutObject"]
    resources = ["arn:aws:s3:::${var.name_prefix}-centralized-logs/cloudfront/*"]

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }
  }
}

# Athena for log analysis
module "log_analysis" {
  source = "../../base_component/athena"

  name            = "${var.name_prefix}-analysis"
  output_location = "s3://${var.name_prefix}-centralized-logs/athena-results/"
  kms_key_arn     = module.log_storage.kms_key_arn

  tags = var.tags
}
