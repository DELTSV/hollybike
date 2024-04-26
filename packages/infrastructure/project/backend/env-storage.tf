resource "aws_ssm_parameter" "backend_storage_bucket_name" {
  name  = "/${lower(var.namespace)}/backend/${var.environment}/storage_bucket_name"
  value = var.storage_s3_bucket_name
  type  = "String"
}

resource "aws_ssm_parameter" "backend_storage_bucket_region" {
  name  = "/${lower(var.namespace)}/backend/${var.environment}/storage_bucket_region"
  value = var.region
  type  = "String"
}

