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

resource "aws_api_gateway_resource" "signin" {
  rest_api_id = local.apigw_id
  parent_id   = aws_api_gateway_resource.user.id

  path_part = "signin"
}

resource "aws_api_gateway_resource" "confirm" {
  rest_api_id = local.apigw_id
  parent_id   = aws_api_gateway_resource.user.id

  path_part = "confirm"
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
  resource_id     = aws_api_gateway_resource.signin.id
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
