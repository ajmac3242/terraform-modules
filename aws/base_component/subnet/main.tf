# Main Subnet resource
resource "aws_subnet" "this" {
  vpc_id            = var.vpc_id
  cidr_block        = var.cidr_block
  availability_zone = var.availability_zone

  map_public_ip_on_launch = var.map_public_ip_on_launch

  # Merge standard tags with Name tag
  tags = merge(
    var.tags,
    {
      "Name" = var.name
    }
  )
}

# Local variable to support tests/mocking
locals {
  _unused_mock_account_id = var.aws_account_id
}
