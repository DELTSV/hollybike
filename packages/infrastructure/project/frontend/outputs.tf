output "cloudfront_domain_name" {
  description = "The domain name of the CloudFront distribution"
  value       = aws_cloudfront_distribution.cf_dist_frontend.domain_name
}

output "cloudfront_hosted_zone_id" {
  description = "The hosted zone ID of the CloudFront distribution"
  value       = aws_cloudfront_distribution.cf_dist_frontend.hosted_zone_id
}

output "alb_header_value" {
  value       = random_password.alb_header_value.result
  description = "The value of the header to be used for the ALB"
}

output "cloudfront_oai_iam_arn" {
  description = "The ARN of the CloudFront OAI"
  value       = aws_cloudfront_origin_access_identity.oai_frontend.iam_arn
}

output "cf_key_pair_id" {
  description = "The ID of the CloudFront key pair"
  value       = aws_cloudfront_public_key.cf_key.id
}