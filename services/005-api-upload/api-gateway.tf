resource "aws_api_gateway_resource" "resource" {
  rest_api_id = local.apigw_id
  parent_id   = local.apigw_root

  path_part = local.function
}

resource "aws_api_gateway_method" "method" {
  rest_api_id   = local.apigw_id
  resource_id   = aws_api_gateway_resource.resource.id
  http_method   = "POST"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = local.cognito_autorizer

  request_parameters = {
    "method.request.path.proxy" = true,
  }
}

resource "aws_api_gateway_integration" "integration" {
  rest_api_id             = local.apigw_id
  resource_id             = aws_api_gateway_resource.resource.id
  http_method             = aws_api_gateway_method.method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_alias.running.invoke_arn
}

resource "aws_api_gateway_method_response" "response" {
  for_each    = toset(local.api_status_response)
  rest_api_id = local.apigw_id
  resource_id = aws_api_gateway_resource.resource.id
  http_method = aws_api_gateway_method.method.http_method
  status_code = each.value
}

resource "aws_lambda_permission" "apigw_lambda_permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.function_name
  principal     = "apigateway.amazonaws.com"
  qualifier     = aws_lambda_alias.running.name

  source_arn = "arn:aws:execute-api:${local.region}:${var.account_id}:${local.apigw_id}/*/${aws_api_gateway_method.method.http_method}${aws_api_gateway_resource.resource.path}"
}
