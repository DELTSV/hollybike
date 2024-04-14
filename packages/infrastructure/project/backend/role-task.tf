data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_backend_task_execution_role" {
  name               = "ecs-backend-task-execution-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "ecs_backend_task_execution_role_policy" {
  role       = aws_iam_role.ecs_backend_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy" "ecs_backend_task_execution_ssm_role_policy" {
  name = "hollybike-task-execution-role-policy"
  role = aws_iam_role.ecs_backend_task_execution_role.id

  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        "Effect" : "Allow",
        "Action" : [
          "ssm:GetParameters",
          "secretsmanager:GetSecretValue"
        ],
        "Resource" : [
          var.backend_ghcr_access_key_arn
        ]
      },
    ]
  })
}

resource "aws_iam_role_policy" "ecs_backend_task_execution_logs_role_policy" {
  name = "hollybike-backend-task-execution-logs-role-policy"
  role = aws_iam_role.ecs_backend_task_execution_role.id

  policy = jsonencode({
    Version   = "2012-10-17"
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