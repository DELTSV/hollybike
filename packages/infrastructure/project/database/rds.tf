resource "aws_db_instance" "fpr_backend_db" {
  identifier           = "fpr-backend-db"
  allocated_storage    = 10
  db_name              = "fpr_backend_db"
  engine               = "postgres"
  engine_version       = "14.7"
  instance_class       = "db.t3.micro"
  username             = var.rds_pg_username
  password             = var.rds_pg_password
  parameter_group_name = "default.postgres14"
  skip_final_snapshot  = true
  publicly_accessible  = true

  vpc_security_group_ids = [aws_security_group.database_security_group.id]
}