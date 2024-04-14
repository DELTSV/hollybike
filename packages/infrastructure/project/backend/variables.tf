variable "fpr_backend_ghcr_access_key_arn" {
  description = "The ARN of the access key for the GitHub Container Registry"
  type        = string
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

variable "default_vpc_id" {
  type        = string
  description = "The ID of the default VPC"
}

variable "default_vpc_subnet_a_id" {
  type        = string
  description = "The ID of the default VPC subnet A"
}

variable "default_vpc_subnet_b_id" {
  type        = string
  description = "The ID of the default VPC subnet B"
}