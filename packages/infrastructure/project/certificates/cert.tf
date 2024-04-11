resource "aws_acm_certificate" "public-cert-frontend" {
  provider          = aws.virginia
  domain_name       = var.domain_name
  validation_method = "DNS"
}

resource "aws_acm_certificate_validation" "frontend" {
  provider                = aws.virginia
  certificate_arn         = aws_acm_certificate.public-cert-frontend.arn
  validation_record_fqdns = [for record in aws_route53_record.frontend_validation : record.fqdn]
}
