
resource "aws_api_gateway_method" "put" {
  rest_api_id          = local.apigw_id
  resource_id          = aws_api_gateway_resource.myimages.id
  http_method          = "PUT"
  authorization        = "COGNITO_USER_POOLS"
  authorizer_id        = local.cognito_autorizer
  request_validator_id = aws_api_gateway_request_validator.parameters.id

  request_parameters = {
    "method.request.header.Content-Type"         = true,
    "method.request.header.X-Amz-Meta-Accuracy"  = true,
    "method.request.header.X-Amz-Meta-Latitude"  = true,
    "method.request.header.X-Amz-Meta-Longitude" = true,
    "method.request.header.X-Amz-Meta-User-Hash" = true,
    "method.request.header.X-Amz-Meta-Qr-Code"   = true,
  }

  depends_on = [
    aws_api_gateway_resource.myimages
  ]
}

resource "aws_api_gateway_integration" "put" {
  rest_api_id             = local.apigw_id
  resource_id             = aws_api_gateway_resource.myimages.id
  http_method             = "PUT"
  integration_http_method = "PUT"
  type                    = "AWS"
  uri                     = "arn:aws:apigateway:${local.region}:s3:path/${local.images_bucket}/uploaded/{imageid}"
  credentials             = aws_iam_role.myimages.arn

  request_parameters = {
    "integration.request.path.imageid"                = "context.requestId",
    "integration.request.header.Content-Type"         = "method.request.header.Content-Type",
    "integration.request.header.X-Amz-Meta-Accuracy"  = "method.request.header.X-Amz-Meta-Accuracy",
    "integration.request.header.X-Amz-Meta-Latitude"  = "method.request.header.X-Amz-Meta-Latitude",
    "integration.request.header.X-Amz-Meta-Longitude" = "method.request.header.X-Amz-Meta-Longitude",
    "integration.request.header.X-Amz-Meta-User-Hash" = "method.request.header.X-Amz-Meta-User-Hash",
    "integration.request.header.X-Amz-Meta-User-Sub"  = "context.authorizer.claims.sub",
    "integration.request.header.X-Amz-Meta-Qr-Code"   = "method.request.header.X-Amz-Meta-Qr-Code",
  }

  depends_on = [
    aws_api_gateway_method.put
  ]
}

resource "aws_api_gateway_method_response" "put" {
  for_each = local.api_status_response

  rest_api_id         = local.apigw_id
  resource_id         = aws_api_gateway_resource.myimages.id
  http_method         = "PUT"
  status_code         = each.value.code
  response_parameters = { "method.response.header.Access-Control-Allow-Origin" = true }

  depends_on = [
    aws_api_gateway_method.put
  ]
}

resource "aws_api_gateway_integration_response" "put" {
  for_each = {
    "BAD"   = local.api_status_response["BAD"]
    "ERROR" = local.api_status_response["ERROR"]
  }


  rest_api_id       = local.apigw_id
  resource_id       = aws_api_gateway_resource.myimages.id
  http_method       = "PUT"
  status_code       = each.value.code
  selection_pattern = each.value.pattern

  response_parameters = { "method.response.header.Access-Control-Allow-Origin" = "'${local.options_domains}'" }

  depends_on = [
    aws_api_gateway_method.put,
    aws_api_gateway_integration.put,
    aws_api_gateway_method_response.put
  ]
}

resource "aws_api_gateway_integration_response" "put-response" {

  rest_api_id       = local.apigw_id
  resource_id       = aws_api_gateway_resource.myimages.id
  http_method       = "PUT"
  status_code       = "200"
  selection_pattern = "2\\d{2}"

  response_templates = {
    "application/json" = <<EOF
      {
        "ImageID": "$context.requestId"
      }
    EOF
  }

  response_parameters = { "method.response.header.Access-Control-Allow-Origin" = "'${local.options_domains}'" }

  depends_on = [
    aws_api_gateway_method.put,
    aws_api_gateway_integration.put,
    aws_api_gateway_method_response.put
  ]
}
