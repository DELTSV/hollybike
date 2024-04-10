output "cloudfront_domain_name" {
  description = "The domain name of the CloudFront distribution"
  value       = aws_cloudfront_distribution.cf_dist_frontend.domain_name
}

output "cloudfront_hosted_zone_id" {
  description = "The hosted zone ID of the CloudFront distribution"
  value       = aws_cloudfront_distribution.cf_dist_frontend.hosted_zone_id
}