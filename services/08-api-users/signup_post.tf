resource "aws_api_gateway_method" "account_signin_post" {
  rest_api_id   = local.apigw_id
  resource_id   = aws_api_gateway_resource.account_signup.id
  http_method   = "POST"
  authorization = "NONE"
  depends_on    = [aws_api_gateway_resource.account_signup]
}

resource "aws_api_gateway_integration" "account_signin_post" {
  rest_api_id = local.apigw_id
  resource_id = aws_api_gateway_resource.account_signup.id
  http_method = "POST"

  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = "arn:aws:apigateway:${local.region}:cognito-idp:action/SignUp"
  credentials             = aws_iam_role.login.arn

  request_templates = {
    "application/json" = <<EOF
      #set($usr = $input.path('$.email'))
      #set($pwd = $input.path('$.password'))
      #set($name = $input.path('$.name'))
      #set($phone = $input.path('$.phone'))
      #set($document = $input.path('$.document'))
      {
        "ClientId": "${local.account_cognito_client_id}",
        "Password": "$pwd",
        "UserAttributes": [ 
          { "Name": "name","Value": "$name" },
          { "Name": "phone_number","Value": "$phone" },
          { "Name": "custom:document","Value": "$document" }
        ],
        "Username": "$usr"
      }
    EOF
  }

  depends_on = [
    aws_api_gateway_method.account_signin_post
  ]
}

resource "aws_api_gateway_method_response" "account_signin_post" {
  for_each = local.api_status_response

  rest_api_id         = local.apigw_id
  resource_id         = aws_api_gateway_resource.account_signup.id
  http_method         = "POST"
  status_code         = each.value.code
  response_parameters = { "method.response.header.Access-Control-Allow-Origin" = true }

  depends_on = [
    aws_api_gateway_method.account_signin_post
  ]
}

resource "aws_api_gateway_integration_response" "account_signin_post" {
  for_each = local.api_status_response

  rest_api_id         = local.apigw_id
  resource_id         = aws_api_gateway_resource.account_signup.id
  http_method         = "POST"
  status_code         = each.value.code
  selection_pattern   = each.value.pattern
  response_parameters = { "method.response.header.Access-Control-Allow-Origin" = "'${local.options_domains}'" }

  depends_on = [
    aws_api_gateway_method.account_signin_post,
    aws_api_gateway_integration.account_signin_post,
    aws_api_gateway_method_response.account_signin_post
  ]
}
