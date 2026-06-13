# IAM Role and Policy Attachment resources
resource "aws_iam_role" "this" {
  name                 = var.role_name
  description          = var.description
  assume_role_policy   = var.assume_role_policy
  permissions_boundary = var.permissions_boundary_arn

  tags = var.tags
}

# Attach managed policies to the created role
resource "aws_iam_role_policy_attachment" "this" {
  for_each   = toset(var.managed_policy_arns)
  role       = aws_iam_role.this.name
  policy_arn = each.value
}

# Local variable to support tests/mocking
locals {
  _unused_mock_account_id = var.aws_account_id
}
