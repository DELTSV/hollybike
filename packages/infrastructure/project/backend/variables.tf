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

variable "db_url_parameter_arn" {
  description = "The ARN of the parameter store for the database URL"
  type        = string
}

variable "db_username_parameter_arn" {
  description = "The ARN of the parameter store for the database username"
  type        = string
}

variable "db_password_parameter_arn" {
  description = "The ARN of the parameter store for the database password"
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