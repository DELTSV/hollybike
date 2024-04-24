output "public_cert_frontend_arn" {
  value = aws_acm_certificate.public_cert_frontend.arn
  depends_on = [aws_acm_certificate_validation.frontend]
}
