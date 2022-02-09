resource "aws_api_gateway_method" "account_forgot_put" {
  rest_api_id   = local.apigw_id
  resource_id   = aws_api_gateway_resource.account_forgot.id
  http_method   = "PUT"
  authorization = "NONE"
  depends_on    = [aws_api_gateway_resource.account_forgot]
}

resource "aws_api_gateway_integration" "account_forgot_put" {
  rest_api_id             = local.apigw_id
  resource_id             = aws_api_gateway_resource.account_forgot.id
  http_method             = "PUT"
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = "arn:aws:apigateway:${local.region}:cognito-idp:action/ForgotPassword"
  credentials             = aws_iam_role.login.arn

  request_templates = {
    "application/json" = <<EOF
    #set($usr = $input.path('$.email'))
    {
      "ClientId": "${local.account_cognito_client_id}",
      "Username": "$usr"
    }
    EOF
  }

  depends_on = [
    aws_api_gateway_method.account_forgot_put
  ]
}

resource "aws_api_gateway_method_response" "account_forgot_put" {
  for_each = local.api_status_response

  rest_api_id         = local.apigw_id
  resource_id         = aws_api_gateway_resource.account_forgot.id
  http_method         = "PUT"
  status_code         = each.value.code
  response_parameters = { "method.response.header.Access-Control-Allow-Origin" = true }

  depends_on = [
    aws_api_gateway_method.account_forgot_put
  ]
}

resource "aws_api_gateway_integration_response" "account_forgot_put" {
  for_each = local.api_status_response

  rest_api_id         = local.apigw_id
  resource_id         = aws_api_gateway_resource.account_forgot.id
  http_method         = "PUT"
  status_code         = each.value.code
  selection_pattern   = each.value.pattern
  response_parameters = { "method.response.header.Access-Control-Allow-Origin" = "'${local.options_domains}'" }

  depends_on = [
    aws_api_gateway_method.account_forgot_put,
    aws_api_gateway_integration.account_forgot_put,
    aws_api_gateway_method_response.account_forgot_put
  ]
}
