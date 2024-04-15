module "frontend" {
  source = "./frontend"

  domain_name              = var.domain_name
  public-cert-frontend-arn = module.certificates.public-cert-frontend-arn
}

module "secrets" {
  source = "./secrets"

  ghcr_username = var.ghcr_username
  ghcr_password = var.ghcr_password

  region = var.region
}

module "network" {
  source = "./network"
}

module "backend" {
  source = "./backend"

  region          = var.region
  ghcr_image_name = var.ghcr_image_name
  ghcr_password   = var.ghcr_password
  ghcr_username   = var.ghcr_username
  ghcr_image_tag  = var.ghcr_image_tag

  public_cert_backend_arn = module.certificates.public-cert-backend-arn

  db_connection_string = module.database.db_connection_string
  rds_pg_password      = var.rds_pg_password
  rds_pg_username      = var.rds_pg_username

  az_count    = var.az_count
  namespace   = var.namespace
  environment = var.environment
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