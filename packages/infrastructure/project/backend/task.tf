resource "aws_ecs_task_definition" "default" {
  family             = "${var.namespace}_ECS_TaskDefinition_${var.environment}"
  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn      = aws_iam_role.ecs_task_iam_role.arn

  container_definitions = jsonencode([
    {
      name = "backend"
      image : "ghcr.io/${lower(var.ghcr_image_name)}:${lower(var.ghcr_image_tag)}",
      repositoryCredentials : {
        "credentialsParameter" : aws_secretsmanager_secret.backend_ghcr_credentials.arn
      },
      cpu       = 256
      memory    = 256
      essential = true
      secrets : [
        {
          name : "DB_URL",
          valueFrom : var.db_url_parameter_arn
        },
        {
          name : "DB_USERNAME",
          valueFrom : var.db_username_parameter_arn
        },
        {
          name : "DB_PASSWORD",
          valueFrom : var.db_password_parameter_arn
        }
      ]
      portMappings = [
        {
          containerPort = 8080
          hostPort      = 0
          protocol      = "tcp"
        }
      ]
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
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.log_group.name,
          "awslogs-region"        = var.region,
          "awslogs-stream-prefix" = "app"
        }
      }
    }
  ])
}

