variable "project_name" { default = "example" }
variable "project_domain" { default = "example.com" }
variable "project_tags" { default = {} }
variable "env" { default = "dev" }

locals {
  api_domain = join(".", ["api", var.project_domain])
  auth_domain = join(".", ["auth", var.project_domain])
  www_domain = join(".", ["www", var.project_domain])
}

module "acm_us_east" {
  source  = "terraform-aws-modules/acm/aws"
  version = "~> 2.0"

  providers = {
    aws = aws.us_east
  }

  domain_name = var.project_domain
  zone_id     = data.aws_route53_zone.primary.zone_id

  subject_alternative_names = concat([
      local.api_domain,
      local.auth_domain,
      local.www_domain
  ])

  wait_for_validation = true
  validation_allow_overwrite_records = true

  tags = merge(var.project_tags)
}

module "cognito" {
  source = "../"

  name = "${var.project_name}-${var.env}"

  admin_create_user_only = true

  domain = local.auth_domain

  certificate_arn = module.acm_us_east.this_acm_certificate_arn

  tags = var.project_tags

  invite_email_message = "your username is {username} and temporary password is {####} for https://${local.www_domain}/home"

  clients = {
    "admin" = {
      generate_secret = false
      explicit_auth_flows = ["ALLOW_USER_PASSWORD_AUTH", "ALLOW_REFRESH_TOKEN_AUTH"]
      callback_urls = [
        "https://${local.auth_domain}/oauth2/idpresponse",
        "https://${local.www_domain}/oauth2/idpresponse",
        "http://localhost:8000/oauth2/idpresponse"
      ]
      logout_urls = [
        "https://${local.auth_domain}/logout",
        "https://${local.www_domain}/logout",
        "http://localhost:8000/logout"
      ]
      allowed_oauth_flows = [
        "code",
        "implicit"
      ]
      allowed_oauth_scopes = [
        "aws.cognito.signin.user.admin",
        "openid",
        "email",
        "profile"
      ]
    }
  }
}

