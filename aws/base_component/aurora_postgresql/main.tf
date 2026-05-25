# Cluster Parameter Group
resource "aws_rds_cluster_parameter_group" "this" {
  name        = "${var.cluster_identifier}-parameter-group"
  family      = var.db_cluster_parameter_group_family
  description = "Parameter group for Aurora PostgreSQL cluster ${var.cluster_identifier}"

  parameter {
    name         = "rds.allowed_extensions"
    value        = "pgvector,aws_lambda,aws_s3"
    apply_method = "pending-reboot"
  }

  tags = var.tags
}

# DB Subnet Group
resource "aws_db_subnet_group" "this" {
  name       = "${var.cluster_identifier}-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = var.tags
}

# Security Group
resource "aws_security_group" "this" {
  name        = "${var.cluster_identifier}-sg"
  description = "Security group for Aurora PostgreSQL cluster ${var.cluster_identifier}"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow PostgreSQL traffic from within VPC"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_block]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

# Aurora Cluster
resource "aws_rds_cluster" "this" {
  cluster_identifier = var.cluster_identifier

  engine         = "aurora-postgresql"
  engine_version = var.engine_version
  database_name  = var.database_name

  master_username = var.master_username
  master_password = var.master_password

  db_subnet_group_name            = aws_db_subnet_group.this.name
  vpc_security_group_ids          = [aws_security_group.this.id]
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.this.name

  storage_encrypted = true
  kms_key_id        = var.kms_key_arn

  iam_database_authentication_enabled = true

  skip_final_snapshot = true

  tags = var.tags
}

# Cluster Instances
resource "aws_rds_cluster_instance" "this" {
  count = var.instances_count

  identifier         = "${var.cluster_identifier}-instance-${count.index}"
  cluster_identifier = aws_rds_cluster.this.id
  instance_class     = var.instance_class
  engine             = aws_rds_cluster.this.engine
  engine_version     = aws_rds_cluster.this.engine_version

  db_subnet_group_name = aws_db_subnet_group.this.name

  tags = var.tags
}

# IAM Role for S3 Integration
module "rds_s3_role" {
  count  = var.s3_import_bucket_arn != null ? 1 : 0
  source = "../iam"

  role_name   = "${var.cluster_identifier}-s3-import-role"
  description = "IAM role for Aurora PostgreSQL S3 import"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "rds.amazonaws.com"
        }
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_policy" "s3_access" {
  count       = var.s3_import_bucket_arn != null ? 1 : 0
  name        = "${var.cluster_identifier}-s3-access"
  description = "Policy for Aurora to access S3 for import"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["s3:GetObject", "s3:ListBucket"]
        Effect   = "Allow"
        Resource = [var.s3_import_bucket_arn, "${var.s3_import_bucket_arn}/*"]
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "s3_access" {
  count      = var.s3_import_bucket_arn != null ? 1 : 0
  role       = module.rds_s3_role[0].role_name
  policy_arn = aws_iam_policy.s3_access[0].arn
}

resource "aws_rds_cluster_role_association" "s3_import" {
  count                 = var.s3_import_bucket_arn != null ? 1 : 0
  db_cluster_identifier = aws_rds_cluster.this.id
  role_arn              = module.rds_s3_role[0].role_arn
  feature_name          = "s3Import"
}

# IAM Role for Lambda Integration
module "rds_lambda_role" {
  count  = length(var.lambda_invocation_arns) > 0 ? 1 : 0
  source = "../iam"

  role_name   = "${var.cluster_identifier}-lambda-invoke-role"
  description = "IAM role for Aurora PostgreSQL Lambda invocation"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "rds.amazonaws.com"
        }
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_policy" "lambda_invocation" {
  count       = length(var.lambda_invocation_arns) > 0 ? 1 : 0
  name        = "${var.cluster_identifier}-lambda-invocation"
  description = "Policy for Aurora to invoke Lambda functions"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = "lambda:InvokeFunction"
        Effect   = "Allow"
        Resource = var.lambda_invocation_arns
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "lambda_invocation" {
  count      = length(var.lambda_invocation_arns) > 0 ? 1 : 0
  role       = module.rds_lambda_role[0].role_name
  policy_arn = aws_iam_policy.lambda_invocation[0].arn
}

resource "aws_rds_cluster_role_association" "lambda" {
  count                 = length(var.lambda_invocation_arns) > 0 ? 1 : 0
  db_cluster_identifier = aws_rds_cluster.this.id
  role_arn              = module.rds_lambda_role[0].role_arn
  feature_name          = "Lambda"
}
