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

resource "aws_vpc_endpoint" "secretsmanager_vpc_endpoint" {
  vpc_endpoint_type = "Interface"
  vpc_id            = var.default_vpc_id
  service_name      = "com.amazonaws.${var.region}.secretsmanager"
}