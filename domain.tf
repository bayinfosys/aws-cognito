resource "aws_cognito_user_pool_domain" "default" {
  domain          = var.domain
  user_pool_id    = aws_cognito_user_pool.default.id
  certificate_arn = var.certificate_arn
}
