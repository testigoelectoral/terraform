
resource "aws_api_gateway_method" "confirm_put" {
  rest_api_id = local.apigw_id
  resource_id = aws_api_gateway_resource.confirm.id

  http_method   = "PUT"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "confirm_put" {
  rest_api_id = local.apigw_id
  resource_id = aws_api_gateway_resource.confirm.id
  http_method = aws_api_gateway_method.confirm_put.http_method

  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = "arn:aws:apigateway:${local.region}:cognito-idp:action/ResendConfirmationCode"
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
}

resource "aws_api_gateway_method_response" "confirm_put" {
  for_each = local.api_status_response

  rest_api_id         = local.apigw_id
  resource_id         = aws_api_gateway_resource.confirm.id
  http_method         = aws_api_gateway_method.confirm_put.http_method
  status_code         = each.value.code
  response_parameters = { "method.response.header.Access-Control-Allow-Origin" = true }

}

resource "aws_api_gateway_integration_response" "confirm_put" {
  for_each = local.api_status_response

  rest_api_id         = local.apigw_id
  resource_id         = aws_api_gateway_resource.confirm.id
  http_method         = aws_api_gateway_method.confirm_put.http_method
  status_code         = each.value.code
  selection_pattern   = each.value.pattern
  response_parameters = { "method.response.header.Access-Control-Allow-Origin" = "'${local.options_domains}'" }

  depends_on = [
    aws_api_gateway_method_response.confirm_put
  ]
}
