resource "aws_ssm_parameter" "backend_db_url" {
  name  = "/hollybike/backend/db_url"
  value = var.db_connection_string
  type  = "String"
}

resource "aws_ssm_parameter" "backend_db_username" {
  name  = "/hollybike/backend/db_username"
  value = var.rds_pg_username
  type  = "String"
}

resource "aws_ssm_parameter" "backend_db_password" {
  name  = "/hollybike/backend/db_password"
  value = var.rds_pg_password
  type  = "SecureString"
}

resource "aws_secretsmanager_secret" "backend_ghcr_credentials" {
  name                    = "hollybike-backend-gcr-access-key"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "backend_ghcr_credentials_version" {
  secret_id     = aws_secretsmanager_secret.backend_ghcr_credentials.id
  secret_string = jsonencode({
    "username" : var.ghcr_username,
    "password" : var.ghcr_password
  })
}