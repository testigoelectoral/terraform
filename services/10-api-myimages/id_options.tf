resource "aws_api_gateway_method" "id_options" {
  rest_api_id = local.apigw_id
  resource_id = aws_api_gateway_resource.id_image.id

  http_method   = "OPTIONS"
  authorization = "NONE"

  depends_on = [
    aws_api_gateway_resource.id_image
  ]
}

resource "aws_api_gateway_integration" "id_options" {
  rest_api_id = local.apigw_id
  resource_id = aws_api_gateway_resource.id_image.id
  http_method = aws_api_gateway_method.id_options.http_method

  type = "MOCK"

  request_templates = {
    "application/json" = <<EOF
      {"statusCode": 200}
    EOF
  }

  depends_on = [
    aws_api_gateway_method.id_options
  ]
}

resource "aws_api_gateway_integration_response" "id_options" {
  rest_api_id = local.apigw_id
  resource_id = aws_api_gateway_resource.id_image.id
  http_method = aws_api_gateway_method.id_options.http_method

  status_code       = "200"
  selection_pattern = "2\\d{2}"

  response_templates = {
    "application/json" = ""
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Authorization'",
    "method.response.header.Access-Control-Allow-Methods" = "'OPTIONS,GET'",
    "method.response.header.Access-Control-Allow-Origin"  = "'${local.options_domains}'",
  }

  depends_on = [
    aws_api_gateway_method.id_options,
  ]
}

resource "aws_api_gateway_method_response" "id_options" {
  rest_api_id = local.apigw_id
  resource_id = aws_api_gateway_resource.id_image.id
  http_method = aws_api_gateway_method.id_options.http_method

  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin"  = true,
  }

  depends_on = [
    aws_api_gateway_method.id_options,
  ]
}
