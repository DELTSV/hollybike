resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_alb.backend_load_balancer.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

  tags = {
    "Project"   = "HollyBike"
    "ManagedBy" = "Terraform"
  }
}


