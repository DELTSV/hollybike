output "db_url_parameter_arn" {
  value       = aws_ssm_parameter.rds_db_url.arn
  description = "The ARN of the SSM parameter storing the RDS database URL"
}

output "db_username_parameter_arn" {
  value       = aws_ssm_parameter.rds_db_username.arn
  description = "The ARN of the SSM parameter storing the RDS database username"
}

output "db_password_parameter_arn" {
  value       = aws_ssm_parameter.rds_db_password.arn
  description = "The ARN of the SSM parameter storing the RDS database password"
}