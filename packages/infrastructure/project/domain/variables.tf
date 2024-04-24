variable "domain_name" {
  type        = string
  description = "The domain name to use for the Route 53 hosted zone"
}

variable "cloudfront_domain_name" {
  type        = string
  description = "The domain name of the CloudFront distribution"
}

variable "cloudfront_hosted_zone_id" {
  type        = string
  description = "The Route 53 hosted zone ID for the CloudFront distribution"
}

variable "alb_domain_name" {
  type        = string
  description = "The domain name of the ALB"
}

variable "alb_hosted_zone_id" {
  type        = string
  description = "The Route 53 hosted zone ID for the ALB"
}