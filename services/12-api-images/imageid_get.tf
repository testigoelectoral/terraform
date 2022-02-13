
resource "aws_api_gateway_method" "imageid_get" {
  rest_api_id   = local.apigw_id
  resource_id   = aws_api_gateway_resource.images_id.id
  http_method   = "GET"
  authorization = "NONE"

  request_parameters = {
    "method.request.path.imageid"             = true,
    "method.request.header.If-Modified-Since" = false
    "method.request.header.ETag"              = false
  }

  depends_on = [
    aws_api_gateway_resource.images_id
  ]
}

resource "aws_api_gateway_integration" "imageid_get" {
  rest_api_id             = local.apigw_id
  resource_id             = aws_api_gateway_resource.images_id.id
  http_method             = "GET"
  integration_http_method = "GET"
  type                    = "AWS"
  uri                     = format("arn:aws:apigateway:%s:s3:path/%s/uploaded/{imageid}", local.region, local.images_bucket)
  credentials             = aws_iam_role.images.arn

  request_parameters = {
    "integration.request.path.imageid"             = "method.request.path.imageid",
    "integration.request.header.If-Modified-Since" = "method.request.header.If-Modified-Since",
    "integration.request.header.ETag"              = "method.request.header.ETag",
  }

  depends_on = [
    aws_api_gateway_method.imageid_get
  ]
}

resource "aws_api_gateway_method_response" "imageid_get" {
  for_each = {
    "BAD"   = local.api_status_response["BAD"]
    "ERROR" = local.api_status_response["ERROR"]
  }


  rest_api_id = local.apigw_id
  resource_id = aws_api_gateway_resource.images_id.id
  http_method = "GET"
  status_code = each.value.code

  depends_on = [
    aws_api_gateway_method.imageid_get
  ]
}


resource "aws_api_gateway_method_response" "imageid_get-response" {
  rest_api_id = local.apigw_id
  resource_id = aws_api_gateway_resource.images_id.id
  http_method = "GET"
  status_code = "200"

  response_parameters = {
    "method.response.header.Cache-Control" = true,
    "method.response.header.Last-Modified" = true,
    "method.response.header.ETag"          = true,
    "method.response.header.Content-Type"  = true,
  }

  depends_on = [
    aws_api_gateway_method.imageid_get
  ]
}

resource "aws_api_gateway_method_response" "imageid_get-cache" {

  rest_api_id = local.apigw_id
  resource_id = aws_api_gateway_resource.images_id.id
  http_method = "GET"
  status_code = "304"

  response_parameters = {
    "method.response.header.Cache-Control" = true,
    "method.response.header.Last-Modified" = true,
    "method.response.header.ETag"          = true,
    "method.response.header.Content-Type"  = true,
  }

  depends_on = [
    aws_api_gateway_method.imageid_get
  ]
}

resource "aws_api_gateway_integration_response" "imageid_get" {
  for_each = {
    "BAD"   = local.api_status_response["BAD"]
    "ERROR" = local.api_status_response["ERROR"]
  }

  rest_api_id       = local.apigw_id
  resource_id       = aws_api_gateway_resource.images_id.id
  http_method       = "GET"
  status_code       = each.value.code
  selection_pattern = each.value.pattern

  depends_on = [
    aws_api_gateway_method.imageid_get,
    aws_api_gateway_integration.imageid_get,
    aws_api_gateway_method_response.imageid_get,
  ]
}

resource "aws_api_gateway_integration_response" "imageid_get-response" {
  rest_api_id       = local.apigw_id
  resource_id       = aws_api_gateway_resource.images_id.id
  http_method       = "GET"
  status_code       = "200"
  selection_pattern = "2\\d{2}"

  response_parameters = {
    "method.response.header.Cache-Control" = "'private, max-age=31536000'",
    "method.response.header.Last-Modified" = "integration.response.header.Last-Modified",
    "method.response.header.ETag"          = "integration.response.header.ETag",
    "method.response.header.Content-Type"   = "integration.response.header.Content-Type",
  }

  depends_on = [
    aws_api_gateway_method.imageid_get,
    aws_api_gateway_integration.imageid_get,
    aws_api_gateway_method_response.imageid_get-response
  ]
}

resource "aws_api_gateway_integration_response" "imageid_get-cache" {

  rest_api_id       = local.apigw_id
  resource_id       = aws_api_gateway_resource.images_id.id
  http_method       = "GET"
  status_code       = "304"
  selection_pattern = "304"

  response_parameters = {
    "method.response.header.Cache-Control" = "'private, max-age=31536000'"
    "method.response.header.Last-Modified" = "integration.response.header.Last-Modified"
    "method.response.header.ETag"          = "integration.response.header.ETag"
  }

  depends_on = [
    aws_api_gateway_method.imageid_get,
    aws_api_gateway_integration.imageid_get,
    aws_api_gateway_method_response.imageid_get-cache
  ]
}
