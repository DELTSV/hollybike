output "backend_ghcr_access_key_arn" {
  description = "The ARN of the access key for the GitHub Container Registry"
  value       = aws_secretsmanager_secret.backend_ghcr_access_key.arn
}