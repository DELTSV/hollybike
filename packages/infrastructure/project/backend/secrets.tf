resource "aws_secretsmanager_secret" "backend_ghcr_credentials" {
  name                    = "${var.namespace}_BackGHCRCredsSecret_${var.environment}"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "backend_ghcr_credentials_version" {
  secret_id     = aws_secretsmanager_secret.backend_ghcr_credentials.id
  secret_string = jsonencode({
    "username" : var.ghcr_username,
    "password" : var.ghcr_password
  })
}