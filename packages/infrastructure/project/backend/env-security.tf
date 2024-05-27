resource "aws_ssm_parameter" "backend_security_audience" {
  name  = "/${lower(var.namespace)}/backend/${var.environment}/security_audience"
  value = var.domain_name
  type  = "String"
}

resource "aws_ssm_parameter" "backend_security_domain" {
  name  = "/${lower(var.namespace)}/backend/${var.environment}/security_domain"
  value = "https://${var.domain_name}"
  type  = "String"
}

resource "aws_ssm_parameter" "backend_security_realm" {
  name  = "/${lower(var.namespace)}/backend/${var.environment}/security_realm"
  value = "realm"
  type  = "SecureString"
}

resource "aws_ssm_parameter" "backend_security_secret" {
  name  = "/${lower(var.namespace)}/backend/${var.environment}/security_secret"
  value = random_password.security_secret.result
  type  = "SecureString"
}

resource "aws_ssm_parameter" "backend_security_cf_key_pair_id" {
  name  = "/${lower(var.namespace)}/backend/${var.environment}/security_cf_key_pair_id"
  value = var.cf_key_pair_id
  type  = "String"
}

resource "random_password" "security_secret" {
  length            = 40
  special           = true
  min_special       = 5
  override_special  = "!#$%^&*()-_=+[]{}<>:?"
  keepers           = {
    pass_version  = 1
  }
}
