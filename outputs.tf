output "cloudfront_distribution_arn" {
  value = aws_cognito_user_pool_domain.default.cloudfront_distribution_arn
}

output "cloudfront_hosted_zone_id" {
  # This zone_id is fixed
  value = "Z2FDTNDATAQYW2"
}

output "user_pool_arn" {
  value = aws_cognito_user_pool.default.arn
}

output "client_ids" {
  value = {for k,v in var.clients : k => aws_cognito_user_pool_client.default[k].id}
}
