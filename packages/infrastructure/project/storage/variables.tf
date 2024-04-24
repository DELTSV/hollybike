variable "namespace" {
  description = "The namespace for the resources"
  type        = string
}

variable "environment" {
  description = "The environment for the resources"
  type        = string
}

variable "rds_pg_username" {
  type        = string
  description = "Username for the RDS Postgres instance"
}


variable "cloudfront_oai_iam_arn" {
  type        = string
  description = "The ARN of the CloudFront OAI"
}