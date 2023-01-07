variable "name" {
  type = string
  description = "name to assign the user pool"
}

variable "admin_create_user_only" {
  type = bool
  description = "allow admin create user only"
  default = false
}

variable "domain" {
  type = string
  description = "domain to associate with the user pool"
}

variable "certificate_arn" {
  type = string
  description = "ssl certificate arn"
}

variable "tags" {
  type = map(string)
  description = "tags to apply to resources"
}

variable "clients" {
  type = map(object({
    generate_secret = bool

    callback_urls = list(string)
    logout_urls = list(string)

    explicit_auth_flows = list(string)
    allowed_oauth_flows = list(string)
    allowed_oauth_scopes = list(string)
  }))

  description = "list of clients which can access the user pool for auth"
}

variable "invite_email_message" {
  type = string
  description = "email invite message. Must contain {username} and {####} placeholders, for username and temporary password, respectively."
  default = "Your username is {username} and temporary password is {####}."
}

variable "invite_sms_message" {
  type = string
  description = "sms invite message. Must contain {username} and {####} placeholders, for username and temporary password, respectively."
  default = "Your username is {username} and temporary password is {####}."
}

variable "attributes" {
  type = map(object({
    type = string
    name = string
    max_length = number
    min_length = number
  }))
  description = "attributes available for each cognito account"
}
