resource "aws_ecs_cluster" "fpr_backend_cluster" {
  name = "fpr-backend-cluster"
}

resource "aws_ecs_service" "fpr_backend_service" {
  name            = "fpr-backend-service"
  cluster         = aws_ecs_cluster.fpr_backend_cluster.id
  task_definition = aws_ecs_task_definition.fpr_backend_task.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  load_balancer {
    target_group_arn = aws_lb_target_group.target_group.arn
    container_name   = aws_ecs_task_definition.fpr_backend_task.family
    container_port   = 8080
  }

  network_configuration {
    subnets          = [var.default_vpc_subnet_a_id, var.default_vpc_subnet_b_id]
    assign_public_ip = true
    security_groups  = [aws_security_group.backend_security_group.id]
  }
}

resource "aws_security_group" "backend_security_group" {
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
}