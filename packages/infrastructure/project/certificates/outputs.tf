output "public-cert-frontend-arn" {
  value = aws_acm_certificate.public-cert-frontend.arn
  depends_on = [aws_acm_certificate_validation.frontend]
}

output "public-cert-backend-arn" {
  value = aws_acm_certificate.public-cert-backend.arn
  depends_on = [aws_acm_certificate_validation.api]
}

output "public-cert-backend-domain-name" {
  value = aws_acm_certificate.public-cert-backend.domain_name
}