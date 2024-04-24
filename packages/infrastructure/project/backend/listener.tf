resource "aws_lb_listener_rule" "header_condition" {
  listener_arn = aws_lb_listener.alb_listener.arn

  action {
    type = "forward"
    target_group_arn = aws_alb_target_group.service_target_group.arn
  }

  condition {
    http_header {
      http_header_name = "X-ALB-Header"
      values           = [var.alb_header_value]
    }
  }
}

resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_alb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Access Denied"
      status_code  = "403"
    }
  }

  tags = {
    Name = "${var.namespace}_ALB_Listener_${var.environment}"
  }
}