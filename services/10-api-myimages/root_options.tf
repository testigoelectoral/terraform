resource "aws_api_gateway_method" "root_options" {
  rest_api_id = local.apigw_id
  resource_id = aws_api_gateway_resource.myimages.id

  http_method   = "OPTIONS"
  authorization = "NONE"

  depends_on = [
    aws_api_gateway_resource.id_image
  ]
}

resource "aws_api_gateway_integration" "root_options" {
  rest_api_id = local.apigw_id
  resource_id = aws_api_gateway_resource.myimages.id
  http_method = aws_api_gateway_method.root_options.http_method

  type = "MOCK"

  request_templates = {
    "application/json" = <<EOF
      {"statusCode": 200}
    EOF
  }

  depends_on = [
    aws_api_gateway_method.root_options
  ]
}

resource "aws_api_gateway_integration_response" "root_options" {
  rest_api_id = local.apigw_id
  resource_id = aws_api_gateway_resource.myimages.id
  http_method = aws_api_gateway_method.root_options.http_method

  status_code       = "200"
  selection_pattern = "2\\d{2}"

  response_templates = {
    "application/json" = ""
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Authorization,Content-Type,X-Amz-Meta-Accuracy,X-Amz-Meta-Latitude,X-Amz-Meta-Longitude,X-Amz-Meta-User-Hash,X-Amz-Meta-Qr-Code'",
    "method.response.header.Access-Control-Allow-Methods" = "'OPTIONS,GET,PUT'",
    "method.response.header.Access-Control-Allow-Origin"  = "'${local.options_domains}'",
  }

  depends_on = [
    aws_api_gateway_method.root_options,
  ]
}

resource "aws_api_gateway_method_response" "root_options" {
  rest_api_id = local.apigw_id
  resource_id = aws_api_gateway_resource.myimages.id
  http_method = aws_api_gateway_method.root_options.http_method

  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin"  = true,
  }

  depends_on = [
    aws_api_gateway_method.root_options,
  ]
}
