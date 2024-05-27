variable "namespace" {
  description = "The namespace for the resources"
  type        = string
}

variable "environment" {
  description = "The environment for the resources"
  type        = string
}

variable "domain_name" {
  type        = string
  description = "The domain name to use for the Route 53 hosted zone"
}

variable "alb_domain_name" {
  type        = string
  description = "The DNS name of the ALB"
}


variable "public_cert_frontend_arn" {
  type        = string
  description = "The ARN of the public certificate for the frontend"
}

variable "application_storage_bucket_id" {
  type = string
  description = "The ID of the S3 bucket used for application storage"
}

variable "application_storage_bucket_domain_name" {
  type = string
  description = "The domain name of the S3 bucket used for application storage"
}

variable "cf_key_json_output" {
  type = string
  description = "The JSON output of the CloudFront public key"
}