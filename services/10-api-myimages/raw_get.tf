
resource "aws_api_gateway_method" "raw_get" {
  rest_api_id = local.apigw_id
  resource_id = aws_api_gateway_resource.raw.id

  http_method          = "GET"
  authorization        = "COGNITO_USER_POOLS"
  authorizer_id        = local.cognito_autorizer
  request_validator_id = aws_api_gateway_request_validator.parameters.id

  request_parameters = {
    "method.request.path.imageid"             = true,
    "method.request.header.If-Modified-Since" = false
    "method.request.header.ETag"              = false
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
    "integration.request.path.sub"                 = "context.authorizer.claims.sub",
    "integration.request.path.imageid"             = "method.request.path.imageid",
    "integration.request.header.If-Modified-Since" = "method.request.header.If-Modified-Since",
    "integration.request.header.ETag"              = "method.request.header.ETag",
  }

  depends_on = [
    aws_api_gateway_method.raw_get
  ]
}

resource "aws_api_gateway_method_response" "raw_get" {
  for_each = {
    "BAD"   = local.api_status_response["BAD"]
    "ERROR" = local.api_status_response["ERROR"]
  }


  rest_api_id = local.apigw_id
  resource_id = aws_api_gateway_resource.raw.id
  http_method = aws_api_gateway_method.raw_get.http_method

  status_code = each.value.code

  response_parameters = { "method.response.header.Access-Control-Allow-Origin" = true }

  depends_on = [
    aws_api_gateway_method.raw_get
  ]
}


resource "aws_api_gateway_method_response" "raw_get-response" {

  rest_api_id = local.apigw_id
  resource_id = aws_api_gateway_resource.raw.id
  http_method = aws_api_gateway_method.raw_get.http_method

  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
    "method.response.header.Cache-Control"               = true
    "method.response.header.Last-Modified"               = true
    "method.response.header.ETag"                        = true
  }

  depends_on = [
    aws_api_gateway_method.raw_get
  ]
}

resource "aws_api_gateway_method_response" "raw_get-cache" {

  rest_api_id = local.apigw_id
  resource_id = aws_api_gateway_resource.raw.id
  http_method = aws_api_gateway_method.raw_get.http_method

  status_code = "304"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
    "method.response.header.Cache-Control"               = true
    "method.response.header.Last-Modified"               = true
    "method.response.header.ETag"                        = true
  }

  depends_on = [
    aws_api_gateway_method.raw_get
  ]
}

resource "aws_api_gateway_integration_response" "raw_get" {
  for_each = {
    "BAD"   = local.api_status_response["BAD"]
    "ERROR" = local.api_status_response["ERROR"]
  }

  rest_api_id = local.apigw_id
  resource_id = aws_api_gateway_resource.raw.id
  http_method = aws_api_gateway_method.raw_get.http_method

  status_code       = aws_api_gateway_method_response.raw_get[each.key].status_code
  selection_pattern = each.value.pattern

  response_parameters = { "method.response.header.Access-Control-Allow-Origin" = "'${local.options_domains}'" }

  depends_on = [
    aws_api_gateway_method_response.raw_get
  ]
}

resource "aws_api_gateway_integration_response" "raw_get-response" {

  rest_api_id = local.apigw_id
  resource_id = aws_api_gateway_resource.raw.id
  http_method = aws_api_gateway_method.raw_get.http_method

  status_code       = "200"
  selection_pattern = "2\\d{2}"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'${local.options_domains}'"
    "method.response.header.Cache-Control"               = "'private, max-age=31536000'"
    "method.response.header.Last-Modified"               = "integration.response.header.Last-Modified"
    "method.response.header.ETag"                        = "integration.response.header.ETag"

  }

  depends_on = [
    aws_api_gateway_method_response.raw_get-response
  ]
}

resource "aws_api_gateway_integration_response" "raw_get-cache" {

  rest_api_id = local.apigw_id
  resource_id = aws_api_gateway_resource.raw.id
  http_method = aws_api_gateway_method.raw_get.http_method

  status_code       = "304"
  selection_pattern = "304"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'${local.options_domains}'"
    "method.response.header.Cache-Control"               = "'private, max-age=31536000'"
    "method.response.header.Last-Modified"               = "integration.response.header.Last-Modified"
    "method.response.header.ETag"                        = "integration.response.header.ETag"
  }

  depends_on = [
    aws_api_gateway_method_response.raw_get-cache
  ]
}
