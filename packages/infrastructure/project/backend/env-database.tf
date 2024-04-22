
resource "aws_ssm_parameter" "backend_db_url" {
  name  = "/${lower(var.namespace)}/backend/${var.environment}/db_url"
  value = var.rds_db_url
  type  = "String"
}

resource "aws_ssm_parameter" "backend_db_username" {
  name  = "/${lower(var.namespace)}/backend/${var.environment}/db_username"
  value = var.rds_db_username
  type  = "String"
}

resource "aws_ssm_parameter" "backend_db_password" {
  name  = "/${lower(var.namespace)}/backend/${var.environment}/db_password"
  value = var.rds_db_password
  type  = "SecureString"
}