resource "aws_cognito_user_pool_client" "default" {
  for_each = var.clients

  name = each.key

  user_pool_id = aws_cognito_user_pool.default.id
  generate_secret = each.value.generate_secret

  supported_identity_providers = ["COGNITO"]

  explicit_auth_flows = each.value.explicit_auth_flows

  callback_urls = each.value.callback_urls

  # https://www.integralist.co.uk/posts/cognito/#terraform-example
  read_attributes  = ["email"]
  write_attributes = ["email"]

  # FIXME: these logout urls are incorrect
  logout_urls                  = each.value.logout_urls
  allowed_oauth_flows          = each.value.allowed_oauth_flows
  allowed_oauth_flows_user_pool_client = true

  allowed_oauth_scopes = each.value.allowed_oauth_scopes
}
