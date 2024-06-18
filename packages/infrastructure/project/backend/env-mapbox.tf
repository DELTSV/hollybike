resource "aws_ssm_parameter" "backend_mapbox_public_token" {
  name  = "/${lower(var.namespace)}/backend/${var.environment}/mapbox_public_token"
  value = var.storage_s3_bucket_name
  type  = "SecureString"
}

