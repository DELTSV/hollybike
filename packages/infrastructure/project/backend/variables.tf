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

variable "domain_name" {
  description = "The domain name for the resources"
  type        = string
}

variable "public_cert_backend_arn" {
  description = "The ARN of the certificate for the backend"
  type        = string
}

variable "rds_db_url" {
  description = "The URL of the RDS database"
  type        = string
}

variable "rds_db_username" {
  description = "The username of the RDS database"
  type        = string
}

variable "rds_db_password" {
  description = "The password of the RDS database"
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

variable "ghcr_password" {
  type        = string
  description = "The password for the GitHub Container Registry"
}

variable "ghcr_image_name" {
  type        = string
  description = "The name of the image in the GitHub Container Registry"
}

variable "ghcr_image_tag" {
  type        = string
  description = "The tag of the image in the GitHub Container Registry"
}

variable "public_subnet_list" {
  type        = list(string)
  description = "List of public subnet IDs"
}

variable "vpc_id" {
  type        = string
  description = "The VPC ID"
}

variable "alb_header_value" {
  type        = string
  description = "The header value to check for"
}