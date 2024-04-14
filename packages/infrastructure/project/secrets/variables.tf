variable "ghcr_username" {
  type        = string
  description = "The username for the GitHub Container Registry"
}

variable "ghcr_password" {
  type        = string
  description = "The password for the GitHub Container Registry"
}

variable "region" {
  type        = string
  description = "The region to deploy the resources"
}

variable "default_vpc_id" {
    type        = string
    description = "The default VPC ID"
}