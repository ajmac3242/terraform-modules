# Main EC2 Instance resource
resource "aws_instance" "this" {
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = var.subnet_id

  vpc_security_group_ids = var.vpc_security_group_ids

  # Enforce root block device encryption
  root_block_device {
    encrypted  = true
    kms_key_id = var.kms_key_arn
  }

  user_data = var.user_data

  monitoring = true

  tags = merge(
    {
      Name = var.name
    },
    var.tags
  )
}
