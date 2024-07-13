variable "namespace" {
  description = "The namespace for the resources"
  type        = string
  default     = "HollyBike"
}

variable "environment" {
  description = "The environment for the resources"
  type        = string
  default     = "Prod"
}

variable "az_count" {
  description = "The number of availability zones to use"
  type        = number
  default     = 3
}

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

variable "api_subdomain" {
  type        = string
  description = "The subdomain for the API"
  default     = "api"
}

variable "rds_pg_username" {
  type        = string
  default     = "postgres"
  description = "Username for the RDS Postgres instance"
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
  default     = "hollybike"
  description = "The name of the image in the GitHub Container Registry"
}

variable "ghcr_image_tag" {
  type        = string
  default     = "latest"
  description = "The tag of the image in the GitHub Container Registry"
}

variable "backend_smtp_url" {
  type        = string
  default     = "smtp-relay.brevo.com"
  description = "The url of the SMTP server"
}

variable "backend_smtp_port" {
  type        = string
  default     = "587"
  description = "The port of the SMTP server"
}

variable "backend_smtp_username" {
  type        = string
  description = "The username of the SMTP server"
}

variable "backend_smtp_password" {
  type        = string
  description = "The password of the SMTP server"
}

variable "backend_mapbox_public_token" {
  type        = string
  description = "The public token for Mapbox (optional)"
}