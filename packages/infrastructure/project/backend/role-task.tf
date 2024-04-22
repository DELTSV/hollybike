resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "${var.namespace}_ECS_TaskExecutionRole_${var.environment}"
  assume_role_policy = data.aws_iam_policy_document.task_assume_role_policy.json
}

data "aws_iam_policy_document" "task_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role" "ecs_task_iam_role" {
  name               = "${var.namespace}_ECS_TaskIAMRole_${var.environment}"
  assume_role_policy = data.aws_iam_policy_document.task_assume_role_policy.json
}

resource "aws_iam_role_policy" "ecs_backend_task_execution_ssm_role_policy" {
  name = "${var.namespace}_ECS_SSM_TaskIAMRole_${var.environment}"
  role = aws_iam_role.ecs_task_execution_role.id

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
          aws_secretsmanager_secret.backend_ghcr_credentials.arn,
          aws_ssm_parameter.backend_db_url.arn,
          aws_ssm_parameter.backend_db_username.arn,
          aws_ssm_parameter.backend_db_password.arn,
          aws_ssm_parameter.backend_security_audience.arn,
          aws_ssm_parameter.backend_security_domain.arn,
          aws_ssm_parameter.backend_security_realm.arn,
          aws_ssm_parameter.backend_security_secret.arn,
        ]
      },
    ]
  })
}