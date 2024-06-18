resource "aws_ssm_parameter" "backend_smtp_url" {
  name  = "/${lower(var.namespace)}/backend/${var.environment}/smtp_url"
  value = var.smtp_url
  type  = "String"
}

resource "aws_ssm_parameter" "backend_smtp_port" {
  name  = "/${lower(var.namespace)}/backend/${var.environment}/smtp_port"
  value = var.smtp_port
  type  = "String"
}

resource "aws_ssm_parameter" "backend_smtp_sender" {
  name  = "/${lower(var.namespace)}/backend/${var.environment}/smtp_sender"
  value = var.smtp_sender
  type  = "String"
}

resource "aws_ssm_parameter" "backend_smtp_username" {
  name  = "/${lower(var.namespace)}/backend/${var.environment}/smtp_username"
  value = var.smtp_username
  type  = "String"
}

resource "aws_ssm_parameter" "backend_smtp_password" {
  name  = "/${lower(var.namespace)}/backend/${var.environment}/smtp_password"
  value = var.smtp_password
  type  = "SecureString"
}
