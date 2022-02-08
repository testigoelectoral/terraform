resource "aws_api_gateway_resource" "account" {
  rest_api_id = local.apigw_id
  parent_id   = local.apigw_root
  path_part   = "account"
}

resource "aws_api_gateway_resource" "account_login" {
  rest_api_id = local.apigw_id
  parent_id   = aws_api_gateway_resource.account.id
  path_part   = "login"
  depends_on  = [aws_api_gateway_resource.account]
}

resource "aws_api_gateway_resource" "account_signup" {
  rest_api_id = local.apigw_id
  parent_id   = aws_api_gateway_resource.account.id
  path_part   = "signup"
  depends_on  = [aws_api_gateway_resource.account]
}

resource "aws_api_gateway_resource" "account_confirm" {
  rest_api_id = local.apigw_id
  parent_id   = aws_api_gateway_resource.account.id
  path_part   = "confirm"
  depends_on  = [aws_api_gateway_resource.account]
}

resource "aws_api_gateway_resource" "account_token" {
  rest_api_id = local.apigw_id
  parent_id   = aws_api_gateway_resource.account.id
  path_part   = "token"
  depends_on  = [aws_api_gateway_resource.account]
}

resource "aws_api_gateway_resource" "account_forgot" {
  rest_api_id = local.apigw_id
  parent_id   = aws_api_gateway_resource.account.id
  path_part   = "forgot"
  depends_on  = [aws_api_gateway_resource.account]
}

resource "aws_api_gateway_resource" "account_password" {
  rest_api_id = local.apigw_id
  parent_id   = aws_api_gateway_resource.account.id
  path_part   = "password"
  depends_on  = [aws_api_gateway_resource.account]
}

################################################################################################### 

module "options_account_login" {
  source          = "./options"
  resource_id     = aws_api_gateway_resource.account_login.id
  depends_on      = [aws_api_gateway_resource.account_login]
  methods         = "POST"
  options_domains = local.options_domains
  apigw_id        = local.apigw_id
}


module "options_account_signin" {
  source          = "./options"
  resource_id     = aws_api_gateway_resource.account_signup.id
  depends_on      = [aws_api_gateway_resource.account_signup]
  methods         = "POST"
  options_domains = local.options_domains
  apigw_id        = local.apigw_id
}

module "options_account_confirm" {
  source          = "./options"
  resource_id     = aws_api_gateway_resource.account_confirm.id
  depends_on      = [aws_api_gateway_resource.account_confirm]
  methods         = "POST,PUT"
  options_domains = local.options_domains
  apigw_id        = local.apigw_id
}

module "options_account_token" {
  source          = "./options"
  resource_id     = aws_api_gateway_resource.account_token.id
  depends_on      = [aws_api_gateway_resource.account_token]
  methods         = "POST"
  options_domains = local.options_domains
  apigw_id        = local.apigw_id
}

module "options_account_forgot" {
  source          = "./options"
  resource_id     = aws_api_gateway_resource.account_forgot.id
  depends_on      = [aws_api_gateway_resource.account_forgot]
  methods         = "POST,PUT"
  options_domains = local.options_domains
  apigw_id        = local.apigw_id
}

module "options_account_password" {
  source          = "./options"
  resource_id     = aws_api_gateway_resource.account_password.id
  depends_on      = [aws_api_gateway_resource.account_password]
  methods         = "POST"
  options_domains = local.options_domains
  apigw_id        = local.apigw_id
}

################################################################################################### 
################################################################################################### 
################################################################################################### 

resource "aws_api_gateway_resource" "user" {
  rest_api_id = local.apigw_id
  parent_id   = local.apigw_root

  path_part = "user"
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
