# Launch Template for ASG instances
resource "aws_launch_template" "this" {
  name_prefix   = "${var.name}-"
  image_id      = var.image_id
  instance_type = var.instance_type

  vpc_security_group_ids = var.security_group_ids

  # Enforce EBS encryption with CMK
  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = 20
      encrypted   = true
      kms_key_id  = var.kms_key_arn
    }
  }

  monitoring {
    enabled = true
  }

  tag_specifications {
    resource_type = "instance"
    tags          = var.tags
  }

  tag_specifications {
    resource_type = "volume"
    tags          = var.tags
  }

  tags = var.tags
}

# Auto Scaling Group resource
resource "aws_autoscaling_group" "this" {
  name                = var.name
  vpc_zone_identifier = var.vpc_zone_identifier
  min_size            = var.min_size
  max_size            = var.max_size
  desired_capacity    = var.desired_capacity

  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }

  dynamic "tag" {
    for_each = var.tags
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
}
