output "rds_db_url" {
  value       = "jdbc:postgresql://${aws_db_instance.backend_db.address}:${aws_db_instance.backend_db.port}/${aws_db_instance.backend_db.db_name}"
  description = "The URL of the RDS database"
}

output "rds_db_password" {
  value       = random_password.master_password.result
  description = "The password of the RDS database"
}