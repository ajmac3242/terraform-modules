# IAM Policy for the Step Functions State Machine
resource "aws_iam_policy" "this" {
  name        = "${var.name}-policy"
  description = "Policy for Step Functions state machine ${var.name} to invoke Lambdas and log to CloudWatch"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = concat(
      [
        {
          Action = [
            "logs:CreateLogDelivery",
            "logs:GetLogDelivery",
            "logs:UpdateLogDelivery",
            "logs:DeleteLogDelivery",
            "logs:ListLogDeliveries",
            "logs:PutResourcePolicy",
            "logs:DescribeResourcePolicies",
            "logs:DescribeLogGroups"
          ]
          Effect   = "Allow"
          Resource = "*"
        }
      ],
      length(var.lambda_arns) > 0 ? [
        {
          Action   = "lambda:InvokeFunction"
          Effect   = "Allow"
          Resource = var.lambda_arns
        }
      ] : []
    )
  })

  tags = var.tags
}

# IAM Role for the Step Functions State Machine
module "role" {
  source = "../../base_component/iam"

  role_name   = "${var.name}-role"
  description = "Execution role for Step Functions state machine ${var.name}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "states.amazonaws.com"
        }
      },
    ]
  })
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/CloudWatchLambdaInsightsExecutionRolePolicy",
    "arn:aws:iam::aws:policy/AWSXrayWriteOnlyAccess"
  ]

  permissions_boundary_arn = var.permissions_boundary_arn

  tags = var.tags
}

# Attach the custom policy to the role
resource "aws_iam_role_policy_attachment" "custom" {
  role       = module.role.role_name
  policy_arn = aws_iam_policy.this.arn
}

# Step Functions State Machine using base module
module "step_functions" {
  count  = var.skip_sfn_creation ? 0 : 1
  source = "../../base_component/step_functions"

  name                        = var.name
  definition                  = var.definition
  role_arn                    = module.role.role_arn
  type                        = var.type
  kms_key_arn                 = var.kms_key_arn
  log_group_retention_in_days = var.log_group_retention_in_days
  aws_account_id              = var.aws_account_id

  tags = var.tags
}
