resource "aws_route53_record" "frontend_validation" {
  provider = aws.virginia
  for_each = {
    for dvo in aws_acm_certificate.public-cert-frontend.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = var.route53_hosted_zone_id
}


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
