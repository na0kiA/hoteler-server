resource "aws_lb" "this" {
  name = "${local.service_name}-jp"

  internal           = false
  load_balancer_type = "application"

  access_logs {
    bucket  = data.terraform_remote_state.log_alb.outputs.s3_bucket_this_id
    enabled = true
    prefix  = "hoteler-jp"
  }

  security_groups = [
    data.terraform_remote_state.network_main.outputs.security_group_web_id,
    data.terraform_remote_state.network_main.outputs.security_group_ecs_id
  ]

  subnets = [
    for s in data.terraform_remote_state.network_main.outputs.subnet_public : s.id
  ]

  tags = {
    Name = "${local.service_name}-jp"
  }
}

resource "aws_lb_listener" "https" {
  certificate_arn   = aws_acm_certificate.root.arn
  load_balancer_arn = aws_lb.this.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"

  default_action {
    type = "forward"

    target_group_arn = aws_lb_target_group.blue_tg.arn
  }
}

resource "aws_lb_listener" "redirect_http_to_https" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "custom_10080" {
  load_balancer_arn = aws_lb.this.arn
  port              = "10080"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.green_tg.arn
  }
}

resource "aws_lb_target_group" "blue_tg" {
  name                 = "${local.service_name}-blue-tg"
  deregistration_delay = 300
  port                 = 80
  protocol             = "HTTP"
  target_type          = "ip"
  vpc_id               = data.terraform_remote_state.network_main.outputs.vpc_this_id

  health_check {
    healthy_threshold   = 3
    interval            = 60
    matcher             = 200
    path                = "/v1/healthcheck"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
  }

  depends_on = [aws_lb.this]
}

resource "aws_lb_target_group" "green_tg" {
  name                 = "${local.service_name}-green-tg"
  deregistration_delay = 300
  port                 = 10080
  protocol             = "HTTP"
  target_type          = "ip"
  vpc_id               = data.terraform_remote_state.network_main.outputs.vpc_this_id

  health_check {
    healthy_threshold   = 3
    interval            = 60
    matcher             = 200
    path                = "/v1/healthcheck"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
  }

  depends_on = [aws_lb.this]
}