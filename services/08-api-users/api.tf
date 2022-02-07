resource "aws_api_gateway_resource" "user" {
  rest_api_id = local.apigw_id
  parent_id   = local.apigw_root

  path_part = "user"
}

resource "aws_api_gateway_request_validator" "validator" {
  name                        = "validate-user"
  rest_api_id                 = local.apigw_id
  validate_request_body       = false
  validate_request_parameters = true
}

resource "aws_api_gateway_resource" "login" {
  rest_api_id = local.apigw_id
  parent_id   = aws_api_gateway_resource.user.id

  path_part = "login"
}

resource "aws_api_gateway_resource" "signup" {
  rest_api_id = local.apigw_id
  parent_id   = aws_api_gateway_resource.user.id

  path_part = "signup"
}

resource "aws_api_gateway_resource" "confirm" {
  rest_api_id = local.apigw_id
  parent_id   = aws_api_gateway_resource.user.id

  path_part = "confirm"
}

resource "aws_api_gateway_resource" "token" {
  rest_api_id = local.apigw_id
  parent_id   = aws_api_gateway_resource.user.id

  path_part = "token"
}

resource "aws_api_gateway_resource" "forgot" {
  rest_api_id = local.apigw_id
  parent_id   = aws_api_gateway_resource.user.id

  path_part = "forgot"
}

resource "aws_api_gateway_resource" "password" {
  rest_api_id = local.apigw_id
  parent_id   = aws_api_gateway_resource.user.id

  path_part = "password"
}

################################################################################################### 

module "options_login" {
  source          = "./options"
  resource_id     = aws_api_gateway_resource.login.id
  methods         = "POST"
  options_domains = local.options_domains
  apigw_id        = local.apigw_id
}


module "options_signin" {
  source          = "./options"
  resource_id     = aws_api_gateway_resource.signup.id
  methods         = "POST"
  options_domains = local.options_domains
  apigw_id        = local.apigw_id
}

module "options_confirm" {
  source          = "./options"
  resource_id     = aws_api_gateway_resource.confirm.id
  methods         = "POST,PUT"
  options_domains = local.options_domains
  apigw_id        = local.apigw_id
}

module "options_token" {
  source          = "./options"
  resource_id     = aws_api_gateway_resource.token.id
  methods         = "POST"
  options_domains = local.options_domains
  apigw_id        = local.apigw_id
}

module "options_forgot" {
  source          = "./options"
  resource_id     = aws_api_gateway_resource.forgot.id
  methods         = "POST,PUT"
  options_domains = local.options_domains
  apigw_id        = local.apigw_id
}

module "options_password" {
  source          = "./options"
  resource_id     = aws_api_gateway_resource.password.id
  methods         = "POST"
  options_domains = local.options_domains
  apigw_id        = local.apigw_id
}
