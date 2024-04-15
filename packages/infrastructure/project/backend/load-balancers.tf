resource "aws_alb" "alb" {
  name            = "${var.namespace}-ALB-${var.environment}"
  security_groups = [aws_security_group.alb.id]
  subnets         = aws_default_subnet.public.*.id
}