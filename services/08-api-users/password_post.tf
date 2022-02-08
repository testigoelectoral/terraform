resource "aws_api_gateway_method" "account_password_post" {
  rest_api_id   = local.apigw_id
  resource_id   = aws_api_gateway_resource.account_password.id
  http_method   = "POST"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = local.cognito_autorizer
  depends_on    = [aws_api_gateway_resource.account_password]
}

resource "aws_api_gateway_integration" "account_password_post" {
  rest_api_id             = local.apigw_id
  resource_id             = aws_api_gateway_resource.account_password.id
  http_method             = "POST"
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = "arn:aws:apigateway:${local.region}:cognito-idp:action/ChangePassword"
  credentials             = aws_iam_role.login.arn

  request_templates = {
    "application/json" = <<EOF
    #set($token = $input.path('$.access_token'))
    #set($oldPwd = $input.path('$.previous_password'))
    #set($newPwd = $input.path('$.proposed_password'))
    {
      "ClientId": "${local.account_cognito_client_id}",
      "AccessToken": "$token",
      "PreviousPassword": "$oldPwd",
      "ProposedPassword": "$newPwd"
    }
    EOF
  }

  depends_on = [
    aws_api_gateway_method.account_password_post
  ]
}

resource "aws_api_gateway_method_response" "account_password_post" {
  for_each = local.api_status_response

  rest_api_id         = local.apigw_id
  resource_id         = aws_api_gateway_resource.account_password.id
  http_method         = "POST"
  status_code         = each.value.code
  response_parameters = { "method.response.header.Access-Control-Allow-Origin" = true }

  depends_on = [
    aws_api_gateway_method.account_password_post
  ]
}

resource "aws_api_gateway_integration_response" "account_password_post" {
  for_each = local.api_status_response

  rest_api_id         = local.apigw_id
  resource_id         = aws_api_gateway_resource.account_password.id
  http_method         = "POST"
  status_code         = each.value.code
  selection_pattern   = each.value.pattern
  response_parameters = { "method.response.header.Access-Control-Allow-Origin" = "'${local.options_domains}'" }

  depends_on = [
    aws_api_gateway_method.account_password_post,
    aws_api_gateway_integration.account_password_post,
    aws_api_gateway_method_response.account_password_post
  ]
}

################################################################################################### 
################################################################################################### 
################################################################################################### 

resource "aws_api_gateway_method" "password_post" {
  rest_api_id   = local.apigw_id
  resource_id   = aws_api_gateway_resource.password.id
  http_method   = "POST"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = local.cognito_autorizer
}

resource "aws_api_gateway_integration" "password_post" {
  rest_api_id             = local.apigw_id
  resource_id             = aws_api_gateway_resource.password.id
  http_method             = "POST"
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = "arn:aws:apigateway:${local.region}:cognito-idp:action/ChangePassword"
  credentials             = aws_iam_role.login.arn

  request_templates = {
    "application/json" = <<EOF
    #set($token = $input.path('$.access_token'))
    #set($oldPwd = $input.path('$.previous_password'))
    #set($newPwd = $input.path('$.proposed_password'))
    {
      "ClientId": "${local.cognito_client_id}",
      "AccessToken": "$token",
      "PreviousPassword": "$oldPwd",
      "ProposedPassword": "$newPwd"
    }
    EOF
  }

  depends_on = [
    aws_api_gateway_method.password_post
  ]
}

resource "aws_api_gateway_method_response" "password_post" {
  for_each = local.api_status_response

  rest_api_id         = local.apigw_id
  resource_id         = aws_api_gateway_resource.password.id
  http_method         = "POST"
  status_code         = each.value.code
  response_parameters = { "method.response.header.Access-Control-Allow-Origin" = true }

  depends_on = [
    aws_api_gateway_method.password_post
  ]
}

resource "aws_api_gateway_integration_response" "password_post" {
  for_each = local.api_status_response

  rest_api_id         = local.apigw_id
  resource_id         = aws_api_gateway_resource.password.id
  http_method         = "POST"
  status_code         = each.value.code
  selection_pattern   = each.value.pattern
  response_parameters = { "method.response.header.Access-Control-Allow-Origin" = "'${local.options_domains}'" }

  depends_on = [
    aws_api_gateway_method.password_post,
    aws_api_gateway_integration.password_post,
    aws_api_gateway_method_response.password_post
  ]
}
