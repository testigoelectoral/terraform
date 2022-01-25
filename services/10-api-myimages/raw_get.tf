
resource "aws_api_gateway_method" "raw_get" {
  rest_api_id = local.apigw_id
  resource_id = aws_api_gateway_resource.raw.id

  http_method          = "GET"
  authorization        = "COGNITO_USER_POOLS"
  authorizer_id        = local.cognito_autorizer
  request_validator_id = aws_api_gateway_request_validator.parameters.id

  request_parameters = {
    "method.request.path.imageid" = true,
  }

  depends_on = [
    aws_api_gateway_resource.raw
  ]
}

resource "aws_api_gateway_integration" "raw_get" {
  rest_api_id = local.apigw_id
  resource_id = aws_api_gateway_resource.raw.id
  http_method = aws_api_gateway_method.raw_get.http_method

  integration_http_method = "GET"
  type                    = "AWS"
  uri                     = format("arn:aws:apigateway:%s:s3:path/%s/{sub}/{imageid}", local.region, local.images_bucket)
  credentials             = aws_iam_role.myimages.arn

  request_parameters = {
    "integration.request.path.sub"     = "context.authorizer.claims.sub",
    "integration.request.path.imageid" = "method.request.path.imageid",
  }

  depends_on = [
    aws_api_gateway_method.raw_get
  ]
}

resource "aws_api_gateway_method_response" "raw_get" {
  for_each = local.api_status_response

  rest_api_id = local.apigw_id
  resource_id = aws_api_gateway_resource.raw.id
  http_method = aws_api_gateway_method.raw_get.http_method

  status_code = each.value.code

  depends_on = [
    aws_api_gateway_method.raw_get
  ]
}

resource "aws_api_gateway_integration_response" "raw_get" {
  for_each = local.api_status_response

  rest_api_id = local.apigw_id
  resource_id = aws_api_gateway_resource.raw.id
  http_method = aws_api_gateway_method.raw_get.http_method

  status_code       = aws_api_gateway_method_response.raw_get[each.key].status_code
  selection_pattern = each.value.pattern

  depends_on = [
    aws_api_gateway_method_response.raw_get
  ]
}
