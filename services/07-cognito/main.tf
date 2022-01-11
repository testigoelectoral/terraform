
resource "aws_cognito_user_pool" "testigo" {

  name                       = "pool-testigo-${var.environment}"
  alias_attributes           = ["email", "phone_number"]
  auto_verified_attributes   = ["email"]
  email_verification_subject = "${var.environment == "prod" ? "" : format("[%s] ", upper(var.environment))}Codigo de verificacion para testigoelectoral.org"
  email_verification_message = "Por favor use el siguiente código: {####}"

  password_policy {
    minimum_length                   = 8
    require_lowercase                = true
    require_numbers                  = true
    require_symbols                  = true
    require_uppercase                = true
    temporary_password_validity_days = 7
  }

  username_configuration {
    case_sensitive = false
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

  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    name                     = "phone_number"
    required                 = true
    string_attribute_constraints {
      min_length = 10
      max_length = 15
    }
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
    name                     = "hash"
    required                 = false

    string_attribute_constraints {
      min_length = 7
      max_length = 512
    }
  }

  lambda_config {
    post_confirmation = local.userhash_arn
  }

}

resource "aws_cognito_user_pool_client" "testigo" {
  name                                 = "client-testigo-${var.environment}"
  user_pool_id                         = aws_cognito_user_pool.testigo.id
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows                  = ["code", "implicit"]
  allowed_oauth_scopes                 = ["email", "phone", "openid"]
  explicit_auth_flows                  = ["ALLOW_USER_PASSWORD_AUTH", "ALLOW_REFRESH_TOKEN_AUTH"]
  callback_urls                        = ["https://${local.domain}", "https://${local.app_domain}"]
  prevent_user_existence_errors        = "ENABLED"
  supported_identity_providers         = ["COGNITO"]
  id_token_validity                    = 60
  access_token_validity                = 60
  refresh_token_validity               = 30

  token_validity_units {
    access_token  = "minutes"
    id_token      = "minutes"
    refresh_token = "days"
  }
}

resource "aws_cognito_user_pool_domain" "testigo" {
  domain          = local.cognito_domain
  certificate_arn = local.cognito_cert
  user_pool_id    = aws_cognito_user_pool.testigo.id
}

resource "aws_route53_record" "cognito" {
  name    = aws_cognito_user_pool_domain.testigo.domain
  type    = "A"
  zone_id = data.aws_route53_zone.testigo.zone_id
  alias {
    evaluate_target_health = false
    name                   = aws_cognito_user_pool_domain.testigo.cloudfront_distribution_arn
    # This zone_id is fixed
    zone_id = "Z2FDTNDATAQYW2"
  }
}

resource "aws_api_gateway_authorizer" "authorizer" {
  name          = "CognitoUserPoolAuthorizer"
  type          = "COGNITO_USER_POOLS"
  rest_api_id   = local.apigw_id
  provider_arns = [aws_cognito_user_pool.testigo.arn]
}

