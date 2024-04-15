resource "aws_alb_listener" "alb_default_listener_https" {
  load_balancer_arn = aws_alb.alb.arn
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = var.public_cert_backend_arn
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-Ext-2018-06"

  #   default_action {
  #     type = "fixed-response"
  #
  #     fixed_response {
  #       content_type = "text/plain"
  #       message_body = "Access denied"
  #       status_code  = "403"
  #     }
  #   }

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.service_target_group.arn
  }
}

resource "aws_alb_target_group" "service_target_group" {
  name                 = "${var.namespace}-TargetGroup-${var.environment}"
  port                 = "80"
  protocol             = "HTTP"
  vpc_id               = aws_default_vpc.default.id
  deregistration_delay = 120

  health_check {
    healthy_threshold   = "2"
    unhealthy_threshold = "2"
    interval            = "60"
    matcher             = "200"
    path                = "/api"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = "30"
  }

  depends_on = [aws_alb.alb]
}

