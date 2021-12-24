
resource "aws_cognito_user_pool" "testigo" {

  name = "pool-testigo-${var.environment}"

  email_verification_subject = "${var.environment == "prod" ? "" : format("[%s] ",upper(var.environment))}Codigo de verificacion para testigoelectoral.org"
  email_verification_message = "Por favor use el siguiente código: {####}"
  alias_attributes           = ["email"]
  auto_verified_attributes   = ["email"]

  password_policy {
    minimum_length    = 8
    require_lowercase = true
    require_numbers   = true
    require_symbols   = true
    require_uppercase = true
  }

  username_configuration {
    case_sensitive = false
  }

  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    name                     = "name"
    required                 = true

    string_attribute_constraints {
      min_length = 1
      max_length = 256
    }
  }

  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    name                     = "email"
    required                 = true

    string_attribute_constraints {
      min_length = 7
      max_length = 256
    }
  }

}

resource "aws_cognito_user_pool_client" "testigo" {
  name                = "client-testigo-${var.environment}"
  explicit_auth_flows = ["ALLOW_USER_PASSWORD_AUTH", "ALLOW_REFRESH_TOKEN_AUTH"]
  user_pool_id        = aws_cognito_user_pool.testigo.id
}
