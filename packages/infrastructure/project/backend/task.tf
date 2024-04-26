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
          valueFrom : aws_ssm_parameter.backend_db_url.arn
        },
        {
          name : "DB_USERNAME",
          valueFrom : aws_ssm_parameter.backend_db_username.arn
        },
        {
          name : "DB_PASSWORD",
          valueFrom : aws_ssm_parameter.backend_db_password.arn
        },
        {
          name : "SECURITY_AUDIENCE",
          valueFrom : aws_ssm_parameter.backend_security_audience.arn
        },
        {
          name : "SECURITY_DOMAIN",
          valueFrom : aws_ssm_parameter.backend_security_domain.arn
        },
        {
          name : "SECURITY_REALM",
          valueFrom : aws_ssm_parameter.backend_security_realm.arn
        },
        {
          name : "SECURITY_SECRET",
          valueFrom : aws_ssm_parameter.backend_security_secret.arn
        },
        {
          name : "STORAGE_S3_BUCKET_NAME",
          valueFrom : aws_ssm_parameter.backend_storage_bucket_name.arn
        },
        {
          name : "STORAGE_S3_BUCKET_REGION",
          valueFrom : aws_ssm_parameter.backend_storage_bucket_region.arn
        },
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

