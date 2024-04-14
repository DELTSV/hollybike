data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_fpr_backend_task_execution_role" {
  name               = "ecs-fpr-backend-task-execution-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "ecs_fpr_backend_task_execution_role_policy" {
  role       = aws_iam_role.ecs_fpr_backend_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy" "ecs_fpr_backend_task_execution_ssm_role_policy" {
  name = "ecs_task_execution_role_policy"
  role = aws_iam_role.ecs_fpr_backend_task_execution_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Effect" : "Allow",
        "Action" : [
          "ssm:GetParameters",
          "secretsmanager:GetSecretValue"
        ],
        "Resource" : [
          var.fpr_backend_ghcr_access_key_arn
        ]
      },
    ]
  })
}

resource "aws_iam_role_policy" "ecs_fpr_backend_task_execution_logs_role_policy" {
  name = "ecs-fpr-backend-task-execution-logs-role-policy"
  role = aws_iam_role.ecs_fpr_backend_task_execution_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect : "Allow",
        Action : [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogStreams"
        ],
        Resource : [
          "arn:aws:logs:*:*:*"
        ]
      },
    ]
  })
}

resource "aws_ecs_task_definition" "fpr_backend_task" {
  family = "fpr-backend-task"

  container_definitions = jsonencode([
    {
      name : "fpr-backend-task",
      image : "ghcr.io/${var.ghcr_username}/${var.ghcr_image_name}:${var.ghcr_image_tag}",
      repositoryCredentials : {
        "credentialsParameter" : var.fpr_backend_ghcr_access_key_arn
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
          "curl -f http://localhost:8080/actuator/health || exit 1"
        ],
        interval : 10,
        timeout : 5,
        retries : 10,
        startPeriod : 240
      },
      environment : [
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
      memory : 1024,
      cpu : 256
    }
  ])
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  memory                   = 1024
  cpu                      = 256
  execution_role_arn       = aws_iam_role.ecs_fpr_backend_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_fpr_backend_task_execution_role.arn
}
