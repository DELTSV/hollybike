resource "aws_iam_role" "ecs_service_role" {
  name               = "${var.namespace}_ECS_ServiceRole_${var.environment}"
  assume_role_policy = data.aws_iam_policy_document.ecs_service_policy.json
}

data "aws_iam_policy_document" "ecs_service_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ecs.amazonaws.com",]
    }
  }
}

resource "aws_iam_role_policy" "ecs_service_role_policy" {
  name   = "${var.namespace}_ECS_ServiceRolePolicy_${var.environment}"
  policy = data.aws_iam_policy_document.ecs_service_role_policy.json
  role   = aws_iam_role.ecs_service_role.id
}

data "aws_iam_policy_document" "ecs_service_role_policy" {
  statement {
    effect  = "Allow"
    actions = [
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:Describe*",
      "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
      "elasticloadbalancing:DeregisterTargets",
      "elasticloadbalancing:Describe*",
      "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
      "elasticloadbalancing:RegisterTargets",
      "ec2:DescribeTags",
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:DescribeLogStreams",
      "logs:PutSubscriptionFilter",
      "logs:PutLogEvents"
    ]
    resources = ["*"]
  }
}