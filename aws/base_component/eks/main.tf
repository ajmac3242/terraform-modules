# EKS cluster role
module "cluster_role" {
  source = "../iam"

  role_name   = "${var.cluster_name}-cluster-role"
  description = "Role for EKS cluster ${var.cluster_name}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  ]

  tags = var.tags
}

# Main EKS Cluster resource
resource "aws_eks_cluster" "this" {
  name     = var.cluster_name
  role_arn = module.cluster_role.role_arn

  vpc_config {
    subnet_ids = var.subnet_ids
  }

  # Enforce secret encryption using mandatory CMK
  encryption_config {
    provider {
      key_arn = var.kms_key_arn
    }
    resources = ["secrets"]
  }

  tags = var.tags

  depends_on = [
    module.cluster_role
  ]
}
