
resource "aws_api_gateway_method" "signin_post" {
  rest_api_id = local.apigw_id
  resource_id = aws_api_gateway_resource.signin.id

  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "signin_post" {
  rest_api_id = local.apigw_id
  resource_id = aws_api_gateway_resource.signin.id
  http_method = aws_api_gateway_method.signin_post.http_method

  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = "arn:aws:apigateway:${local.region}:cognito-idp:action/SignUp"
  credentials             = aws_iam_role.login.arn

  request_templates = {
    "application/json" = <<EOF
      #set($usr = $input.path('$.username'))
      #set($pwd = $input.path('$.password'))
      #set($name = $input.path('$.name'))
      #set($email = $input.path('$.email'))
      #set($phone = $input.path('$.phone'))
      {
        "ClientId": "${local.cognito_client_id}",
        "Password": "$pwd",
        "UserAttributes": [ 
          { "Name": "name","Value": "$name" },
          { "Name": "email","Value": "$email" },
          { "Name": "phone_number","Value": "$phone" }
        ],
        "Username": "$usr"
      }
    EOF
  }
}

resource "aws_api_gateway_method_response" "signin_post" {
  for_each = local.api_status_response

  rest_api_id         = local.apigw_id
  resource_id         = aws_api_gateway_resource.signin.id
  http_method         = aws_api_gateway_method.signin_post.http_method
  status_code         = each.value.code
  response_parameters = { "method.response.header.Access-Control-Allow-Origin" = true }

}

resource "aws_api_gateway_integration_response" "signin_post" {
  for_each = local.api_status_response

  rest_api_id         = local.apigw_id
  resource_id         = aws_api_gateway_resource.signin.id
  http_method         = aws_api_gateway_method.signin_post.http_method
  status_code         = each.value.code
  selection_pattern   = each.value.pattern
  response_parameters = { "method.response.header.Access-Control-Allow-Origin" = "'${local.options_domains}'" }

  depends_on = [
    aws_api_gateway_method_response.signin_post
  ]
}
