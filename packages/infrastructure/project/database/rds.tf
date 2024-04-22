resource "aws_db_instance" "backend_db" {
  identifier           = "hollybike-db"
  allocated_storage    = 10
  db_name              = "hollybike_db"
  engine               = "postgres"
  engine_version       = "14.10"
  instance_class       = "db.t3.micro"
  username             = var.rds_pg_username
  password             = random_password.master_password.result
  parameter_group_name = "default.postgres14"
  skip_final_snapshot  = true
  publicly_accessible  = true

  vpc_security_group_ids = [aws_security_group.database_security_group.id]

  tags = {
    Name = "${var.namespace}_Backend_DB_${var.environment}"
  }
}