resource "aws_security_group" "load_balancer_security_group" {
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_alb" "fpr_backend_load_balancer" {
  name               = "fpr-backend-load-balancer"
  load_balancer_type = "application"
  subnets            = [
    var.default_vpc_subnet_a_id,
    var.default_vpc_subnet_b_id
  ]
  security_groups = [aws_security_group.load_balancer_security_group.id]
}

resource "aws_lb_target_group" "target_group" {
  name        = "target-group"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"

  health_check {
    enabled             = true
    path                = "/actuator/health"
    port                = "traffic-port"
    protocol            = "HTTP"
    healthy_threshold   = 2
    unhealthy_threshold = 10
    timeout             = 10
    interval            = 30
  }
  vpc_id = var.default_vpc_id
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_alb.fpr_backend_load_balancer.arn
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
}

resource "aws_lb_listener" "listener_tls" {
  load_balancer_arn = aws_alb.fpr_backend_load_balancer.arn
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = var.public_cert_backend_arn
  ssl_policy        = "ELBSecurityPolicy-2016-08"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }


}