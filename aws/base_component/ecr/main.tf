# Automatically manage KMS key if not provided
module "kms" {
  count  = var.existing_kms_key_arn == null ? 1 : 0
  source = "../kms"

  name                 = "${var.name}-ecr-key"
  description          = "KMS key for ECR repository ${var.name}"
  admin_principal_arns = []
  usage_principal_arns = []


  tags = var.tags
}

locals {
  kms_key_arn = var.existing_kms_key_arn != null ? var.existing_kms_key_arn : module.kms[0].key_arn
  default_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep last 30 images"
        selection = {
          tagStatus   = "any"
          countType   = "imageCountMoreThan"
          countNumber = 30
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}

# Main ECR Repository resource
resource "aws_ecr_repository" "this" {
  name                 = var.name
  image_tag_mutability = var.image_tag_mutability

  # Enforce scanning
  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }

  # Enforce KMS encryption with CMK
  encryption_configuration {
    encryption_type = "KMS"
    kms_key         = local.kms_key_arn
  }

  tags = var.tags
}

# Lifecycle Policy
resource "aws_ecr_lifecycle_policy" "this" {
  repository = aws_ecr_repository.this.name

  policy = var.lifecycle_policy != null ? var.lifecycle_policy : local.default_lifecycle_policy
}
