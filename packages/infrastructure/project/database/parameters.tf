resource "random_password" "master_password" {
  length            = 40
  special           = true
  min_special       = 5
  override_special  = "!#$%^&*()-_=+[]{}<>:?"
  keepers           = {
    pass_version  = 1
  }
}

resource "aws_ssm_parameter" "rds_db_url" {
  name  = "/${lower(var.namespace)}/backend/${var.environment}/db_url"
  value = "jdbc:postgresql://${aws_db_instance.backend_db.address}:${aws_db_instance.backend_db.port}/${aws_db_instance.backend_db.db_name}"
  type  = "String"
}

resource "aws_ssm_parameter" "rds_db_username" {
  name  = "/${lower(var.namespace)}/backend/${var.environment}/db_username"
  value = var.rds_pg_username
  type  = "String"
}

resource "aws_ssm_parameter" "rds_db_password" {
  name  = "/${lower(var.namespace)}/backend/${var.environment}/db_password"
  value = random_password.master_password.result
  type  = "SecureString"
}