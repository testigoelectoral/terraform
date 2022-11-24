
resource "aws_cognito_user_pool" "account" {
  name                       = "testigo-${var.environment}"
  auto_verified_attributes   = ["email"]
  username_attributes        = ["email"]
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
      max_length = 128
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
      max_length = 128
    }
  }

  schema {
    attribute_data_type      = "Number"
    developer_only_attribute = false
    mutable                  = true
    name                     = "document"
    required                 = false

    number_attribute_constraints {
      min_value = 99999
      max_value = 20000000000
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

  # lambda_config {
  #   post_confirmation = local.userhash_arn
  # }
}

resource "aws_cognito_user_pool_client" "account" {
  name                          = "testigo-${var.environment}"
  user_pool_id                  = aws_cognito_user_pool.account.id
  explicit_auth_flows           = ["ALLOW_USER_PASSWORD_AUTH", "ALLOW_REFRESH_TOKEN_AUTH"]
  prevent_user_existence_errors = "ENABLED"
  supported_identity_providers  = ["COGNITO"]
  id_token_validity             = 60
  access_token_validity         = 60
  refresh_token_validity        = 3

  token_validity_units {
    access_token  = "minutes"
    id_token      = "minutes"
    refresh_token = "days"
  }
}

resource "aws_api_gateway_authorizer" "authorizer" {
  name          = "CognitoUserPoolAuthorizer"
  type          = "COGNITO_USER_POOLS"
  rest_api_id   = local.apigw_id
  provider_arns = [aws_cognito_user_pool.account.arn]
}
