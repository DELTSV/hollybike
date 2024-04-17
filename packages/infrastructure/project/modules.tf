module "frontend" {
  source = "./frontend"

  domain_name              = var.domain_name
  public-cert-frontend-arn = module.certificates.public-cert-frontend-arn
  environment              = var.environment
  namespace                = var.namespace
}

module "network" {
  source = "./network"

  az_count    = var.az_count
  namespace   = var.namespace
  environment = var.environment
  region      = var.region
}

module "backend" {
  source = "./backend"

  region          = var.region
  ghcr_image_name = var.ghcr_image_name
  ghcr_password   = var.ghcr_password
  ghcr_username   = var.ghcr_username
  ghcr_image_tag  = var.ghcr_image_tag

  public_cert_backend_arn = module.certificates.public-cert-backend-arn

  az_count                  = var.az_count
  namespace                 = var.namespace
  environment               = var.environment
  public_subnet_list        = module.network.public_subnet_list
  private_subnet_list       = module.network.private_subnet_list
  vpc_id                    = module.network.vpc_id
  db_password_parameter_arn = module.database.db_password_parameter_arn
  db_url_parameter_arn      = module.database.db_url_parameter_arn
  db_username_parameter_arn = module.database.db_username_parameter_arn
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

  environment = var.environment
  namespace   = var.namespace
}

module "database" {
  source = "./database"

  rds_pg_username = var.rds_pg_username
  environment     = var.environment
  namespace       = var.namespace
}