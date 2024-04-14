resource "aws_alb" "backend_load_balancer" {
  name               = "hollybike-backend-load-balancer"
  load_balancer_type = "application"
  subnets            = [
    var.default_vpc_subnet_a_id,
    var.default_vpc_subnet_b_id
  ]
  security_groups = [aws_security_group.load_balancer_security_group.id]
}

