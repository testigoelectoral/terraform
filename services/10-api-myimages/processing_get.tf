
resource "aws_api_gateway_method" "processing_get" {
  rest_api_id   = local.apigw_id
  resource_id   = aws_api_gateway_resource.processing.id
  http_method   = "GET"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = local.cognito_autorizer

  depends_on = [
    aws_api_gateway_resource.processing
  ]
}

resource "aws_api_gateway_integration" "processing_get" {
  rest_api_id             = local.apigw_id
  resource_id             = aws_api_gateway_resource.processing.id
  http_method             = "GET"
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = "arn:aws:apigateway:${local.region}:dynamodb:action/Query"
  credentials             = aws_iam_role.myimages.arn

  request_templates = {
    "application/json" = <<EOF
      {
        "TableName": "${local.dynamodb_processing_name}",
        "KeyConditionExpression": "OwnerID = :sub",
        "ExpressionAttributeValues": {
          ":sub": {
              "S": "$context.authorizer.claims.sub"
          }
        }
      }
    EOF
  }

  depends_on = [
    aws_api_gateway_method.processing_get
  ]
}

resource "aws_api_gateway_method_response" "processing_get" {
  for_each = local.api_status_response

  rest_api_id = local.apigw_id
  resource_id = aws_api_gateway_resource.processing.id
  http_method = "GET"
  status_code = each.value.code

  response_parameters = { "method.response.header.Access-Control-Allow-Origin" = true }

  depends_on = [
    aws_api_gateway_method.processing_get
  ]
}

resource "aws_api_gateway_integration_response" "processing_get" {
  for_each = {
    "BAD"   = local.api_status_response["BAD"]
    "ERROR" = local.api_status_response["ERROR"]
  }

  rest_api_id         = local.apigw_id
  resource_id         = aws_api_gateway_resource.processing.id
  http_method         = "GET"
  status_code         = each.value.code
  selection_pattern   = each.value.pattern
  response_parameters = { "method.response.header.Access-Control-Allow-Origin" = "'${local.options_domains}'" }

  depends_on = [
    aws_api_gateway_method.processing_get,
    aws_api_gateway_integration.processing_get,
    aws_api_gateway_method_response.processing_get
  ]
}

resource "aws_api_gateway_integration_response" "processing_get-response" {

  rest_api_id       = local.apigw_id
  resource_id       = aws_api_gateway_resource.processing.id
  http_method       = "GET"
  status_code       = "200"
  selection_pattern = "2\\d{2}"

  response_templates = {
    "application/json" = <<EOF
      #set($inputRoot = $input.path('$'))
      [
        #foreach($elem in $inputRoot.Items) {
        "ImageID": "$elem.ImageID.S",
        "Reason": "$elem.Reason.S",
        "CreatedAt": "$elem.CreatedAt.S"
        }#if($foreach.hasNext),#end
        #end
      ]
    EOF
  }

  response_parameters = { "method.response.header.Access-Control-Allow-Origin" = "'${local.options_domains}'" }

  depends_on = [
    aws_api_gateway_method.processing_get,
    aws_api_gateway_integration.processing_get,
    aws_api_gateway_method_response.processing_get
  ]
}
