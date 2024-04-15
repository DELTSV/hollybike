variable "namespace" {
  description = "The namespace for the resources"
  type        = string
}

variable "environment" {
  description = "The environment for the resources"
  type        = string
}

variable "az_count" {
  description = "The number of availability zones to use"
  type        = number
}

variable "public_cert_backend_arn" {
  description = "The ARN of the certificate for the backend"
  type        = string
}

variable "region" {
  description = "The AWS region"
  type        = string
}

variable "ghcr_username" {
  type        = string
  description = "The username for the GitHub Container Registry"
}

variable "ghcr_image_name" {
  type        = string
  description = "The name of the image in the GitHub Container Registry"
}

variable "ghcr_image_tag" {
  type        = string
  description = "The tag of the image in the GitHub Container Registry"
}


variable "rds_pg_username" {
  type        = string
  description = "Username for the RDS Postgres instance"
}

variable "rds_pg_password" {
  type        = string
  description = "Password for the RDS Postgres instance"
}

variable "db_connection_string" {
  type        = string
  description = "Connection string for the RDS Postgres instance"
}

variable "ghcr_password" {
  type        = string
  description = "The password for the GitHub Container Registry"
}