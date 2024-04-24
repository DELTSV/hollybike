resource "aws_acm_certificate" "public_cert_frontend" {
  provider          = aws.virginia
  domain_name       = var.domain_name
  validation_method = "DNS"

  tags = {
    Name = "${var.namespace}_Frontend_Certificate_${var.environment}"
  }
}

resource "aws_acm_certificate_validation" "frontend" {
  provider                = aws.virginia
  certificate_arn         = aws_acm_certificate.public_cert_frontend.arn
  validation_record_fqdns = [for record in aws_route53_record.frontend_validation : record.fqdn]
}
