# Automatically manage KMS key if not provided
module "kms" {
  count  = var.existing_kms_key_arn == null ? 1 : 0
  source = "../kms"

  name                 = "${var.bucket_name}-key"
  description          = "KMS key for S3 bucket ${var.bucket_name}"
  admin_principal_arns = []
  usage_principal_arns = []
  aws_account_id       = var.aws_account_id

  tags = var.tags
}

locals {
  kms_key_arn = var.existing_kms_key_arn != null ? var.existing_kms_key_arn : module.kms[0].key_arn
}

# S3 Bucket and related security configurations
resource "aws_s3_bucket" "this" {
  bucket        = var.bucket_name
  force_destroy = var.force_destroy

  tags = var.tags
}

# Enforce Server-Side Encryption using KMS
resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = local.kms_key_arn
      sse_algorithm     = "aws:kms"
    }
  }
}

# Block all public access to the bucket
resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Enable versioning for data protection
resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id
  versioning_configuration {
    status = var.versioning_enabled ? "Enabled" : "Suspended"
  }
}

# Enforce bucket ownership controls (no ACLs)
resource "aws_s3_bucket_ownership_controls" "this" {
  bucket = aws_s3_bucket.this.id
  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

# Apply bucket policy to enforce SSL-only access
resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id
  policy = data.aws_iam_policy_document.this.json
}

# IAM policy document for S3 bucket policy
data "aws_iam_policy_document" "this" {
  statement {
    sid     = "EnforceSSLOnly"
    effect  = "Deny"
    actions = ["s3:*"]
    resources = [
      aws_s3_bucket.this.arn,
      "${aws_s3_bucket.this.arn}/*",
    ]

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
}

# Enable server access logging if configured
resource "aws_s3_bucket_logging" "this" {
  count  = var.enable_access_logging ? 1 : 0
  bucket = aws_s3_bucket.this.id

  target_bucket = var.log_bucket_id
  target_prefix = "log/"

  lifecycle {
    precondition {
      condition     = var.log_bucket_id != null
      error_message = "The log_bucket_id must be provided when enable_access_logging is true."
    }
  }
}

# Configure lifecycle rules for object management
resource "aws_s3_bucket_lifecycle_configuration" "this" {
  count  = length(var.lifecycle_rules) > 0 ? 1 : 0
  bucket = aws_s3_bucket.this.id

  dynamic "rule" {
    for_each = var.lifecycle_rules
    content {
      id     = rule.value.id
      status = rule.value.status

      dynamic "expiration" {
        for_each = try([rule.value.expiration], [])
        content {
          days = expiration.value.days
        }
      }

      dynamic "transition" {
        for_each = try(rule.value.transitions, [])
        content {
          days          = transition.value.days
          storage_class = transition.value.storage_class
        }
      }
    }
  }
}
