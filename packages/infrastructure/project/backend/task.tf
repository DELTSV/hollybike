resource "aws_ecs_task_definition" "backend_task" {
  family = "backend-task"

  container_definitions = jsonencode([
    {
      name : "backend-task",
      image : "ghcr.io/${var.ghcr_username}/${var.ghcr_image_name}:${var.ghcr_image_tag}",
      repositoryCredentials : {
        "credentialsParameter" : var.backend_ghcr_access_key_arn
      },
      essential : true,
      portMappings : [
        {
          "containerPort" : 8080,
          "hostPort" : 8080
        }
      ],
      healthCheck : {
        "command" : [
          "CMD-SHELL",
          "curl -f http://localhost:8080/api || exit 1"
        ],
        interval : 30,
        timeout : 5,
        retries : 5,
        startPeriod : 30
      },
      environment : [
        {
          name : "DB_URL",
          value : var.db_connection_string
        },
        {
          name : "DB_USERNAME",
          value : var.rds_pg_username
        },
        {
          name : "DB_PASSWORD",
          value : var.rds_pg_password
        },
      ],
      logConfiguration : {
        logDriver : "awslogs",
        options : {
          awslogs-create-group : "true",
          awslogs-group : "awslogs-backend",
          awslogs-region : var.region,
          awslogs-stream-prefix : "awslogs-backend"
        }
      },
      memoryReservation : 812,
    }
  ])
  requires_compatibilities = ["EC2"]
  network_mode             = "awsvpc"
  execution_role_arn       = aws_iam_role.ecs_backend_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_backend_task_execution_role.arn
}
