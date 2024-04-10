variable "domain_name" {
  type        = string
  description = "The domain name to use for the Route 53 hosted zone"
}


variable "public-cert-frontend-arn" {
  type        = string
  description = "The ARN of the public certificate for the frontend"
}