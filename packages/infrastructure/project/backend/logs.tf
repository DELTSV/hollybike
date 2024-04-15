resource "aws_cloudwatch_log_group" "log_group" {
  name              = "/${lower(var.namespace)}/ecs/backend"
  retention_in_days = 1
}