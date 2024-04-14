resource "aws_lb_listener" "listener_tls" {
  load_balancer_arn = aws_alb.backend_load_balancer.arn
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = var.public_cert_backend_arn
  ssl_policy        = "ELBSecurityPolicy-2016-08"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}

resource "aws_lb_target_group" "target_group" {
  name        = "hollybike-backend-target-group"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"

  health_check {
    enabled             = true
    path                = "/api"
    port                = "traffic-port"
    protocol            = "HTTP"
    healthy_threshold   = 2
    unhealthy_threshold = 10
    timeout             = 10
    interval            = 30
  }

  vpc_id = var.default_vpc_id
}