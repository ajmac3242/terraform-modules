# Create IAM role if execution_role_arn is not provided
module "execution_role" {
  count  = var.execution_role_arn == null ? 1 : 0
  source = "../iam"

  role_name   = "${var.name}-sagemaker-role"
  description = "Execution role for SageMaker inference ${var.name}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "sagemaker.amazonaws.com"
        }
      }
    ]
  })

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonSageMakerFullAccess"
  ]

  tags = var.tags
}

locals {
  role_arn = var.execution_role_arn != null ? var.execution_role_arn : module.execution_role[0].role_arn
}

resource "aws_sagemaker_model" "this" {
  name               = var.name
  execution_role_arn = local.role_arn

  primary_container {
    image = var.container_image
  }

  vpc_config {
    security_group_ids = var.vpc_config.security_group_ids
    subnets            = var.vpc_config.subnets
  }

  tags = var.tags
}

resource "aws_sagemaker_endpoint_configuration" "this" {
  name = var.name

  production_variants {
    variant_name           = "AllTraffic"
    model_name             = aws_sagemaker_model.this.name
    initial_instance_count = 1
    instance_type          = var.instance_type
  }

  kms_key_arn = var.kms_key_arn

  tags = var.tags
}

resource "aws_sagemaker_endpoint" "this" {
  name                 = var.name
  endpoint_config_name = aws_sagemaker_endpoint_configuration.this.name

  tags = var.tags
}
