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

variable "route53_hosted_zone_id" {
  type        = string
  description = "The ID of the Route 53 hosted zone to use for the domain"
}

variable "api_subdomain" {
  type        = string
  description = "The subdomain for the API"
  default     = "api"
}