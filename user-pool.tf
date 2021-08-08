resource "aws_cognito_user_pool" "default" {
  name = var.name

  admin_create_user_config {
    allow_admin_create_user_only = var.admin_create_user_only

    invite_message_template {
      email_subject = "Your temporary password for ${var.name}"
      email_message = var.invite_email_message
      sms_message = var.invite_sms_message
    }
  }

  auto_verified_attributes = ["email"]
  mfa_configuration = "OFF"

  email_configuration {
    email_sending_account = "COGNITO_DEFAULT"
  }

  password_policy {
    minimum_length                   = 8
    require_lowercase                = true
    require_numbers                  = false
    require_symbols                  = false
    require_uppercase                = false
    temporary_password_validity_days = 7
  }

  verification_message_template {
    default_email_option = "CONFIRM_WITH_CODE"
    email_message        = "Your verification code is {####}."
    email_subject        = "Your verification code"
    sms_message          = "Your verification code is {####}."
  }

  tags = var.tags
}
