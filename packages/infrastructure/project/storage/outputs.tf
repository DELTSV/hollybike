output "rds_db_url" {
  value       = "jdbc:postgresql://${aws_db_instance.backend_db.address}:${aws_db_instance.backend_db.port}/${aws_db_instance.backend_db.db_name}"
  description = "The URL of the RDS database"
}

output "rds_db_password" {
  value       = random_password.master_password.result
  description = "The password of the RDS database"
}

output "application_storage_bucket_name" {
  value       = aws_s3_bucket.application_storage.bucket
  description = "The name of the S3 bucket used for application storage"
}

output "application_storage_bucket_id" {
  value       = aws_s3_bucket.application_storage.id
  description = "The ID of the S3 bucket used for application storage"
}

output "application_storage_bucket_arn" {
  value       = aws_s3_bucket.application_storage.arn
  description = "The ARN of the S3 bucket used for application storage"
}

output "application_storage_bucket_domain_name" {
  value       = aws_s3_bucket.application_storage.bucket_regional_domain_name
  description = "The domain name of the S3 bucket used for application storage"
}