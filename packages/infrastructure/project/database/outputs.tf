output "db_connection_string" {
  value = "jdbc:postgresql://${aws_db_instance.backend_db.address}:${aws_db_instance.backend_db.port}/${aws_db_instance.backend_db.db_name}"
}