resource "aws_ecs_cluster" "backend_cluster" {
  name = "hollybike-backend-cluster"

  tags = {
    "Project"   = "HollyBike"
    "ManagedBy" = "Terraform"
  }
}

resource "aws_ecs_service" "backend_service" {
  name            = "hollybike-backend-service"
  cluster         = aws_ecs_cluster.backend_cluster.id
  task_definition = aws_ecs_task_definition.backend_task.arn
  launch_type     = "EC2"
  desired_count   = 1

  load_balancer {
    target_group_arn = aws_lb_target_group.target_group.arn
    container_name   = aws_ecs_task_definition.backend_task.family
    container_port   = 8080
  }

  network_configuration {
    subnets          = [var.default_vpc_subnet_a_id, var.default_vpc_subnet_b_id]
#     assign_public_ip = true
    security_groups  = [aws_security_group.backend_security_group.id]
  }

  tags = {
    "Project"   = "HollyBike"
    "ManagedBy" = "Terraform"
  }
}

resource "aws_security_group" "backend_security_group" {
  name = "hollybike-backend-sg"

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.load_balancer_security_group.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Project"   = "HollyBike"
    "ManagedBy" = "Terraform"
  }
}