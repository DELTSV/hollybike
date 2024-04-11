variable "access_key" {
  description = "AWS access key"
  type        = string
  sensitive   = true
}

variable "secret_access_key" {
  description = "AWS secret key"
  type        = string
  sensitive   = true
}

variable "region" {
  type        = string
  description = "The region where the server will be created"
  default     = "eu-west-3"
}

variable "domain_name" {
  type        = string
  description = "The domain name for the server"
  default     = "hollybike.fr"
}

variable "rds_pg_username" {
  type        = string
  default     = "postgres"
  sensitive   = true
  description = "Username for the RDS Postgres instance"
}

variable "rds_pg_password" {
  type        = string
  sensitive   = true
  description = "Password for the RDS Postgres instance"
}