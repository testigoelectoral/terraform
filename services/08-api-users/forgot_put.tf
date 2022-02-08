
resource "aws_api_gateway_method" "forgot_put" {
  rest_api_id   = local.apigw_id
  resource_id   = aws_api_gateway_resource.forgot.id
  http_method   = "PUT"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "forgot_put" {
  rest_api_id             = local.apigw_id
  resource_id             = aws_api_gateway_resource.forgot.id
  http_method             = "PUT"
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = "arn:aws:apigateway:${local.region}:cognito-idp:action/ForgotPassword"
  credentials             = aws_iam_role.login.arn

  request_templates = {
    "application/json" = <<EOF
    #set($usr = $input.path('$.username'))
    {
      "ClientId": "${local.cognito_client_id}",
      "Username": "$usr"
    }
    EOF
  }

  depends_on = [
    aws_api_gateway_method.forgot_put
  ]
}

resource "aws_api_gateway_method_response" "forgot_put" {
  for_each = local.api_status_response

  rest_api_id         = local.apigw_id
  resource_id         = aws_api_gateway_resource.forgot.id
  http_method         = "PUT"
  status_code         = each.value.code
  response_parameters = { "method.response.header.Access-Control-Allow-Origin" = true }

  depends_on = [
    aws_api_gateway_method.forgot_put
  ]
}

resource "aws_api_gateway_integration_response" "forgot_put" {
  for_each = local.api_status_response

  rest_api_id         = local.apigw_id
  resource_id         = aws_api_gateway_resource.forgot.id
  http_method         = "PUT"
  status_code         = each.value.code
  selection_pattern   = each.value.pattern
  response_parameters = { "method.response.header.Access-Control-Allow-Origin" = "'${local.options_domains}'" }

  depends_on = [
    aws_api_gateway_method.forgot_put,
    aws_api_gateway_integration.forgot_put,
    aws_api_gateway_method_response.forgot_put
  ]
}