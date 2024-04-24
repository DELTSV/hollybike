module "frontend" {
  source = "./frontend"

  application_storage_bucket_domain_name = module.storage.application_storage_bucket_domain_name
  application_storage_bucket_id          = module.storage.application_storage_bucket_id

  domain_name              = var.domain_name
  public_cert_frontend_arn = module.certificates.public_cert_frontend_arn
  environment              = var.environment
  namespace                = var.namespace
  alb_domain_name          = module.backend.alb_domain_name
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
  domain_name     = var.domain_name
  ghcr_image_name = var.ghcr_image_name
  ghcr_password   = var.ghcr_password
  ghcr_username   = var.ghcr_username
  ghcr_image_tag  = var.ghcr_image_tag

  az_count           = var.az_count
  namespace          = var.namespace
  environment        = var.environment
  public_subnet_list = module.network.public_subnet_list
  vpc_id             = module.network.vpc_id
  rds_db_password    = module.storage.rds_db_password
  rds_db_username    = var.rds_pg_username
  rds_db_url         = module.storage.rds_db_url

  alb_header_value = module.frontend.alb_header_value
}

module "domain" {
  source = "./domain"

  domain_name = var.domain_name

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

module "storage" {
  source = "./storage"

  rds_pg_username        = var.rds_pg_username
  environment            = var.environment
  namespace              = var.namespace
  cloudfront_oai_iam_arn = module.frontend.cloudfront_oai_iam_arn
}