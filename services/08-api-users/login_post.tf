
resource "aws_api_gateway_method" "login_post" {
  rest_api_id = local.apigw_id
  resource_id = aws_api_gateway_resource.login.id

  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "login_post" {
  rest_api_id = local.apigw_id
  resource_id = aws_api_gateway_resource.login.id
  http_method = aws_api_gateway_method.login_post.http_method

  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = "arn:aws:apigateway:${local.region}:cognito-idp:action/InitiateAuth"
  credentials             = aws_iam_role.login.arn

  request_templates = {
    "application/json" = <<EOF
      #set($usr = $input.path('$.username'))
      #set($pwd = $input.path('$.password'))
      {
        "AuthFlow": "USER_PASSWORD_AUTH",
        "AuthParameters": { 
          "USERNAME" : "$usr",
          "PASSWORD": "$pwd"
        },
        "ClientId": "${local.cognito_client_id}"
      }
    EOF
  }
}

resource "aws_api_gateway_method_response" "login_post" {
  for_each = local.api_status_response

  rest_api_id         = local.apigw_id
  resource_id         = aws_api_gateway_resource.login.id
  http_method         = aws_api_gateway_method.login_post.http_method
  status_code         = each.value.code
  response_parameters = { "method.response.header.Access-Control-Allow-Origin" = true }
}

resource "aws_api_gateway_integration_response" "login_post" {
  for_each = local.api_status_response

  rest_api_id         = local.apigw_id
  resource_id         = aws_api_gateway_resource.login.id
  http_method         = aws_api_gateway_method.login_post.http_method
  status_code         = each.value.code
  selection_pattern   = each.value.pattern
  response_parameters = { "method.response.header.Access-Control-Allow-Origin" = "'${local.options_domains}'" }

  depends_on = [
    aws_api_gateway_method_response.login_post
  ]
}
