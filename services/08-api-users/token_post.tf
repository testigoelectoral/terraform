
resource "aws_api_gateway_method" "token_post" {
  rest_api_id = local.apigw_id
  resource_id = aws_api_gateway_resource.token.id

  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "token_post" {
  rest_api_id = local.apigw_id
  resource_id = aws_api_gateway_resource.token.id
  http_method = aws_api_gateway_method.token_post.http_method

  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = "arn:aws:apigateway:${local.region}:cognito-idp:action/InitiateAuth"
  credentials             = aws_iam_role.login.arn

  request_templates = {
    "application/json" = <<EOF
      #set($token = $input.path('$.refresh_token'))
      {
        "AuthFlow": "REFRESH_TOKEN_AUTH",
        "AuthParameters": { 
          "REFRESH_TOKEN": "$token"
        },
        "ClientId": "${local.cognito_client_id}"
      }
    EOF
  }
}

resource "aws_api_gateway_method_response" "token_post" {
  for_each = local.api_status_response

  rest_api_id         = local.apigw_id
  resource_id         = aws_api_gateway_resource.token.id
  http_method         = aws_api_gateway_method.token_post.http_method
  status_code         = each.value.code
  response_parameters = { "method.response.header.Access-Control-Allow-Origin" = true }
}

resource "aws_api_gateway_integration_response" "token_post" {
  for_each = local.api_status_response

  rest_api_id         = local.apigw_id
  resource_id         = aws_api_gateway_resource.token.id
  http_method         = aws_api_gateway_method.token_post.http_method
  status_code         = each.value.code
  selection_pattern   = each.value.pattern
  response_parameters = { "method.response.header.Access-Control-Allow-Origin" = "'${local.options_domains}'" }

  depends_on = [
    aws_api_gateway_method_response.token_post
  ]
}
