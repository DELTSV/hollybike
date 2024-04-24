resource "aws_ecs_service" "service" {
  name            = "${var.namespace}_ECS_Service_${var.environment}"
  iam_role        = aws_iam_role.ecs_service_role.arn
  cluster         = aws_ecs_cluster.default.id
  task_definition = aws_ecs_task_definition.default.arn
  desired_count   = 1

  load_balancer {
    target_group_arn = aws_alb_target_group.service_target_group.arn
    container_name   = "backend"
    container_port   = 8080
  }

  ordered_placement_strategy {
    type  = "spread"
    field = "attribute:ecs.availability-zone"
  }

  ordered_placement_strategy {
    type  = "binpack"
    field = "memory"
  }

  lifecycle {
    ignore_changes = [desired_count]
  }

#   depends_on = [aws_alb_listener.alb_default_listener_https]
}