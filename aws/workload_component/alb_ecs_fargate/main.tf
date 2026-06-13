# Data sources to get current AWS region and account ID

data "aws_caller_identity" "current" {
  count = var.aws_account_id == null ? 1 : 0
}

locals {
  account_id = var.aws_account_id != null ? var.aws_account_id : data.aws_caller_identity.current[0].account_id
}

# ALB using base module (conditionally created)
module "alb" {
  count  = var.use_existing_alb ? 0 : 1
  source = "../../base_component/alb"

  name            = var.name
  security_groups = var.alb_security_group_ids
  subnets         = var.public_subnet_ids

  enable_https_listener = var.enable_https
  certificate_arn       = var.certificate_arn
  enable_http_redirect  = var.enable_https

  access_logs_bucket = var.access_logs_bucket
  aws_account_id     = local.account_id

  tags = var.tags
}

# Target Group for ECS Service
resource "aws_lb_target_group" "this" {
  name        = "${var.name}-tg"
  port        = var.container_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    path                = var.health_check_path
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 30
    matcher             = "200"
  }

  tags = var.tags
}

locals {
  listener_arn = var.use_existing_alb ? var.existing_alb_listener_arn : (var.enable_https ? module.alb[0].https_listener_arn : module.alb[0].http_listener_arn)
}

# ALB Listener Rule
resource "aws_lb_listener_rule" "this" {
  listener_arn = local.listener_arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }

  condition {
    path_pattern {
      values = ["/*"]
    }
  }

  tags = var.tags
}

# ECS Fargate Service using base module
module "ecs_fargate" {
  source = "../../base_component/ecs_fargate"

  name               = var.name
  private_subnet_ids = var.private_subnet_ids
  security_group_ids = var.ecs_service_security_group_ids
  container_image    = var.container_image
  container_port     = var.container_port
  cpu                = var.cpu
  memory             = var.memory
  desired_count      = var.desired_count

  load_balancer_config = {
    target_group_arn = aws_lb_target_group.this.arn
    container_name   = var.name
    container_port   = var.container_port
  }

  kms_key_arn              = var.kms_key_arn
  permissions_boundary_arn = var.permissions_boundary_arn
  aws_account_id           = local.account_id

  tags = var.tags
}
