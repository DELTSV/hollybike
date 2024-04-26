data "aws_iam_policy_document" "task_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_task_iam_role" {
  name               = "${var.namespace}_ECS_TaskIAMRole_${var.environment}"
  assume_role_policy = data.aws_iam_policy_document.task_assume_role_policy.json
}

resource "aws_iam_role_policy" "ecs_backend_task_iam_s3_role_policy" {
  name = "${var.namespace}_ECS_S3_TaskIAMRole_${var.environment}"
  role = aws_iam_role.ecs_task_iam_role.id

  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket",
          "s3:GetBucketLocation",
        ],
        "Resource" : [
          var.storage_bucket_arn,
          "${var.storage_bucket_arn}/*"
        ]
      },
    ]
  })
}