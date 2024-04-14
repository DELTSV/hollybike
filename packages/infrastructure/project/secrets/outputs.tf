output "fpr_backend_ghcr_access_key_arn" {
  description = "The ARN of the access key for the GitHub Container Registry"
  value       = aws_secretsmanager_secret.fpr_backend_ghcr_access_key.arn
}