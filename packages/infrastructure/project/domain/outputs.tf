output "route53_hosted_zone_id" {
  description = "The hosted zone ID of the CloudFront distribution"
  value       = data.aws_route53_zone.public.zone_id
}