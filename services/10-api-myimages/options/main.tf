
resource "aws_api_gateway_method" "options" {
  rest_api_id   = var.apigw_id
  resource_id   = var.resource_id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "options" {
  rest_api_id       = var.apigw_id
  resource_id       = var.resource_id
  http_method       = "OPTIONS"
  type              = "MOCK"

  depends_on = [
    aws_api_gateway_method.options
  ]
}

resource "aws_api_gateway_method_response" "options" {
  rest_api_id = var.apigw_id
  resource_id = var.resource_id
  http_method = "OPTIONS"
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin"  = true,
  }

  depends_on = [
    aws_api_gateway_method.options
  ]
}

resource "aws_api_gateway_integration_response" "options" {
  rest_api_id       = var.apigw_id
  resource_id       = var.resource_id
  http_method       = "OPTIONS"
  status_code       = "200"
  selection_pattern = "2\\d{2}"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Authorization,Content-Type,X-Amz-Meta-Accuracy,X-Amz-Meta-Latitude,X-Amz-Meta-Longitude,X-Amz-Meta-User-Hash,X-Amz-Meta-Qr-Code'",
    "method.response.header.Access-Control-Allow-Methods" = "'${var.methods}'",
    "method.response.header.Access-Control-Allow-Origin"  = "'${var.options_domains}'",
  }

  depends_on = [
    aws_api_gateway_method.options,
    aws_api_gateway_integration.options,
    aws_api_gateway_method_response.options
  ]
}
