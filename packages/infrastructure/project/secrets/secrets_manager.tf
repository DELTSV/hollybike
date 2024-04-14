resource "aws_secretsmanager_secret" "fpr_backend_ghcr_access_key" {
  name                    = "fpr-backend-gcr-access-key"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "access_key_v" {
  secret_id     = aws_secretsmanager_secret.fpr_backend_ghcr_access_key.id
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