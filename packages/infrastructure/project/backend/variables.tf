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
  type = list(string)
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

variable "storage_s3_bucket_name" {
  type        = string
  description = "The name of the S3 bucket"
}

variable "storage_bucket_arn" {
  type        = string
  description = "The ARN of the S3 bucket used for application storage"
}

variable "cf_ssm_parameter_arn" {
  type        = string
  description = "The ARN of the SSM parameter for the CloudFront private key"
}

variable "cf_key_pair_id" {
  type        = string
  description = "The ID of the CloudFront key pair"
}

variable "smtp_url" {
  type        = string
  description = "The url of the SMTP server"
}

variable "smtp_sender" {
  type        = string
  description = "The sender of the SMTP server"
}

variable "smtp_port" {
  type        = string
  description = "The port of the SMTP server"
}

variable "smtp_username" {
  type        = string
  description = "The username of the SMTP server"
}

variable "smtp_password" {
  type        = string
  description = "The password of the SMTP server"
}

variable "mapbox_public_token" {
  type        = string
  description = "The public token for Mapbox"
}