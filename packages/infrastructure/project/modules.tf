module "frontend" {
  source = "./frontend"

  domain_name              = var.domain_name
  public-cert-frontend-arn = module.certificates.public-cert-frontend-arn
}

module "domain" {
  source = "./domain"

  domain_name               = var.domain_name
  cloudfront_domain_name    = module.frontend.cloudfront_domain_name
  cloudfront_hosted_zone_id = module.frontend.cloudfront_hosted_zone_id

  providers = {
    aws.virginia = aws.virginia
  }
}

module "certificates" {
  source = "./certificates"

  domain_name            = var.domain_name
  route53_hosted_zone_id = module.domain.route53_hosted_zone_id

  providers = {
    aws.virginia = aws.virginia
  }
}