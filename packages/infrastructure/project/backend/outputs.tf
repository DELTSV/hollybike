output "alb_domain_name" {
  description = "The domain name of the ALB"
  value       = aws_alb.backend_load_balancer.dns_name
}

output "alb_hosted_zone_id" {
  description = "The Route 53 hosted zone ID for the ALB"
  value       = aws_alb.backend_load_balancer.zone_id
}