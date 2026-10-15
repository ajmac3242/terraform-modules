# DB Subnet Group
resource "aws_db_subnet_group" "this" {
  name       = "${var.cluster_identifier}-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = var.tags
}

# Security Group
resource "aws_security_group" "this" {
  name        = "${var.cluster_identifier}-sg"
  description = "Security group for Aurora MySQL cluster ${var.cluster_identifier}"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow MySQL traffic from within VPC"
    from_port   = 3306
    to_port     = 3306
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

# Cluster Parameter Group
resource "aws_rds_cluster_parameter_group" "this" {
  name        = "${var.cluster_identifier}-pg"
  family      = var.db_cluster_parameter_group_family
  description = "RDS cluster parameter group for ${var.cluster_identifier}"

  parameter {
    name  = "server_audit_logging"
    value = "1"
  }

  parameter {
    name  = "server_audit_events"
    value = "CONNECT,QUERY,TABLE"
  }

  tags = var.tags
}

# CloudWatch Log Groups with CMK Encryption
resource "aws_cloudwatch_log_group" "this" {
  for_each = toset(var.enabled_cloudwatch_logs_exports)

  name              = "/aws/rds/cluster/${var.cluster_identifier}/${each.value}"
  retention_in_days = var.log_retention_in_days
  kms_key_id        = coalesce(var.cloudwatch_kms_key_arn, var.kms_key_arn)

  tags = var.tags
}

# Aurora MySQL Cluster
resource "aws_rds_cluster" "this" {
  cluster_identifier = var.cluster_identifier

  engine         = "aurora-mysql"
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

  backup_retention_period = var.backup_retention_period
  storage_type            = var.storage_type

  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports

  dynamic "serverlessv2_scaling_configuration" {
    for_each = var.enable_serverlessv2 && var.serverlessv2_scaling_configuration != null ? [var.serverlessv2_scaling_configuration] : []
    content {
      min_capacity = serverlessv2_scaling_configuration.value.min_capacity
      max_capacity = serverlessv2_scaling_configuration.value.max_capacity
    }
  }

  skip_final_snapshot = true

  tags = var.tags

  depends_on = [aws_cloudwatch_log_group.this]
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

# IAM Role for Kiro Powers (MCP) Control Plane Integration
module "kiro_mcp_control_plane_role" {
  count  = var.enable_kiro_mcp_integration ? 1 : 0
  source = "../iam"

  role_name   = "${var.cluster_identifier}-kiro-control-plane"
  description = "IAM role for Kiro Powers (MCP) control plane monitoring and management"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = concat(
      [
        {
          Action = "sts:AssumeRole"
          Effect = "Allow"
          Principal = {
            Service = "rds.amazonaws.com"
          }
        }
      ],
      length(var.kiro_mcp_principal_arns) > 0 ? [
        {
          Action = "sts:AssumeRole"
          Effect = "Allow"
          Principal = {
            AWS = var.kiro_mcp_principal_arns
          }
        }
      ] : []
    )
  })

  tags = var.tags
}

resource "aws_iam_policy" "kiro_mcp_control_plane" {
  count       = var.enable_kiro_mcp_integration ? 1 : 0
  name        = "${var.cluster_identifier}-kiro-control-plane-policy"
  description = "Policy for Kiro Powers (MCP) control plane metrics and operational insights"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "rds:DescribeDBClusters",
          "rds:DescribeDBInstances",
          "rds:ListTagsForResource",
          "pi:GetResourceMetrics",
          "cloudwatch:GetMetricData"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "kiro_mcp_control_plane" {
  count      = var.enable_kiro_mcp_integration ? 1 : 0
  role       = module.kiro_mcp_control_plane_role[0].role_name
  policy_arn = aws_iam_policy.kiro_mcp_control_plane[0].arn
}

# IAM Role for Kiro Powers (MCP) Data Plane Integration
module "kiro_mcp_data_plane_role" {
  count  = var.enable_kiro_mcp_integration ? 1 : 0
  source = "../iam"

  role_name   = "${var.cluster_identifier}-kiro-data-plane"
  description = "IAM role for Kiro Powers (MCP) data plane database authentication"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = concat(
      [
        {
          Action = "sts:AssumeRole"
          Effect = "Allow"
          Principal = {
            Service = "rds.amazonaws.com"
          }
        }
      ],
      length(var.kiro_mcp_principal_arns) > 0 ? [
        {
          Action = "sts:AssumeRole"
          Effect = "Allow"
          Principal = {
            AWS = var.kiro_mcp_principal_arns
          }
        }
      ] : []
    )
  })

  tags = var.tags
}

resource "aws_iam_policy" "kiro_mcp_data_plane" {
  count       = var.enable_kiro_mcp_integration ? 1 : 0
  name        = "${var.cluster_identifier}-kiro-data-plane-policy"
  description = "Policy for Kiro Powers (MCP) data plane IAM database authentication"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = "rds-db:connect"
        Effect   = "Allow"
        Resource = "arn:aws:rds-db:*:*:dbuser/*/*"
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "kiro_mcp_data_plane" {
  count      = var.enable_kiro_mcp_integration ? 1 : 0
  role       = module.kiro_mcp_data_plane_role[0].role_name
  policy_arn = aws_iam_policy.kiro_mcp_data_plane[0].arn
}
