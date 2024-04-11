resource "aws_route53_record" "frontend" {
  provider = aws.virginia
  name     = var.domain_name
  type     = "A"
  zone_id  = data.aws_route53_zone.public.zone_id

  alias {
    name                   = var.cloudfront_domain_name
    zone_id                = var.cloudfront_hosted_zone_id
    evaluate_target_health = false
  }
}