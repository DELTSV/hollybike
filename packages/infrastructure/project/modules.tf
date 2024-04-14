module "frontend" {
  source = "./frontend"

  domain_name              = var.domain_name
  public-cert-frontend-arn = module.certificates.public-cert-frontend-arn
}

module "secrets" {
  source = "./secrets"

  ghcr_username = var.ghcr_username
  ghcr_password = var.ghcr_password

  default_vpc_id = module.network.default_vpc_id
  region         = var.region
}

module "network" {
  source = "./network"

  region = var.region
}

module "backend" {
  source = "./backend"

  default_vpc_id          = module.network.default_vpc_id
  default_vpc_subnet_a_id = module.network.default_vpc_subnet_a_id
  default_vpc_subnet_b_id = module.network.default_vpc_subnet_b_id

  fpr_backend_ghcr_access_key_arn = module.secrets.fpr_backend_ghcr_access_key_arn
  region                          = var.region
  ghcr_image_name                 = var.ghcr_image_name
  ghcr_username                   = var.ghcr_username
  ghcr_image_tag                  = var.ghcr_image_tag

  public_cert_backend_arn = module.certificates.public-cert-backend-arn
}

module "domain" {
  source = "./domain"

  domain_name         = var.domain_name
  backend_domain_name = module.certificates.public-cert-backend-domain-name

  cloudfront_domain_name    = module.frontend.cloudfront_domain_name
  cloudfront_hosted_zone_id = module.frontend.cloudfront_hosted_zone_id

  alb_domain_name    = module.backend.alb_domain_name
  alb_hosted_zone_id = module.backend.alb_hosted_zone_id

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

module "database" {
  source = "./database"

  rds_pg_username = var.rds_pg_username
  rds_pg_password = var.rds_pg_password
}