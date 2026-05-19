# Glue ETL Pattern Composition

# S3 Buckets for Raw, Processed, and Scripts
module "raw_bucket" {
  source = "../../base_component/s3"

  bucket_name           = "${var.name}-raw"
  existing_kms_key_arn  = var.kms_key_arn
  enable_access_logging = false
  tags                  = var.tags
}

module "processed_bucket" {
  source = "../../base_component/s3"

  bucket_name           = "${var.name}-processed"
  existing_kms_key_arn  = var.kms_key_arn
  enable_access_logging = false
  tags                  = var.tags
}

module "scripts_bucket" {
  source = "../../base_component/s3"

  bucket_name           = "${var.name}-scripts"
  existing_kms_key_arn  = var.kms_key_arn
  enable_access_logging = false
  tags                  = var.tags
}

# Upload ETL Script
resource "aws_s3_object" "etl_script" {
  bucket     = module.scripts_bucket.bucket_id
  key        = "scripts/etl_job.py"
  source     = var.etl_script_path
  kms_key_id = var.kms_key_arn

  tags = var.tags
}

# IAM Role for Glue
module "glue_role" {
  source = "../../base_component/iam"

  role_name   = "${var.name}-glue-role"
  description = "IAM role for Glue ETL job and crawler"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "glue.amazonaws.com"
        }
      }
    ]
  })

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
  ]

  tags = var.tags
}

# Least-privilege IAM Policy for S3 and KMS
resource "aws_iam_policy" "glue_s3_kms" {
  name        = "${var.name}-glue-s3-kms-policy"
  description = "Least-privilege policy for Glue to access S3 and KMS"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ]
        Effect = "Allow"
        Resource = [
          module.raw_bucket.bucket_arn,
          "${module.raw_bucket.bucket_arn}/*",
          module.processed_bucket.bucket_arn,
          "${module.processed_bucket.bucket_arn}/*",
          module.scripts_bucket.bucket_arn,
          "${module.scripts_bucket.bucket_arn}/*"
        ]
      },
      {
        Action = [
          "kms:Decrypt",
          "kms:Encrypt",
          "kms:GenerateDataKey"
        ]
        Effect   = "Allow"
        Resource = [var.kms_key_arn]
      }
    ]
  })

  tags = var.tags
}

# Attach the custom policy to the Glue role
resource "aws_iam_role_policy_attachment" "glue_s3_kms" {
  role       = module.glue_role.role_name
  policy_arn = aws_iam_policy.glue_s3_kms.arn
}

# Glue Components
module "glue" {
  source = "../../base_component/glue"

  name        = var.name
  role_arn    = module.glue_role.role_arn
  kms_key_arn = var.kms_key_arn

  s3_targets = [
    { path = "s3://${module.raw_bucket.bucket_id}/" }
  ]

  command_script_location = "s3://${module.scripts_bucket.bucket_id}/${aws_s3_object.etl_script.key}"
  vpc_config              = var.vpc_config

  tags = var.tags
}
