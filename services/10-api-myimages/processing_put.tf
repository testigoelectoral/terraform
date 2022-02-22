
resource "aws_api_gateway_method" "processing_put" {
  rest_api_id = local.apigw_id
  resource_id = aws_api_gateway_resource.processing.id

  http_method   = "PUT"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = local.cognito_autorizer

  depends_on = [
    aws_api_gateway_resource.processing
  ]
}

resource "aws_api_gateway_integration" "processing_put" {
  rest_api_id = local.apigw_id
  resource_id = aws_api_gateway_resource.processing.id
  http_method = "PUT"

  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = "arn:aws:apigateway:${local.region}:dynamodb:action/PutItem"
  credentials             = aws_iam_role.myimages.arn

  request_templates = {
    "application/json" = <<EOF
      {
        "TableName": "${local.dynamodb_processing_name}",
        "Item": {            
            "OwnerID": {
                "S": "$context.authorizer.claims.sub"
            },
            "ImageID": {
                "S": "$input.path('$.ImageID')"
            },
            "Reason": {
                "S": "$input.path('$.Reason')"
            },
            "CreatedAt": {
                "S": "$context.requestTime"
            }
        },
        "ConditionExpression": "attribute_not_exists(OwnerID)"
      }
    EOF
  }

  depends_on = [
    aws_api_gateway_method.processing_put
  ]
}

resource "aws_api_gateway_method_response" "processing_put" {
  for_each = local.api_status_response

  rest_api_id = local.apigw_id
  resource_id = aws_api_gateway_resource.processing.id
  http_method = "PUT"

  status_code = each.value.code

  response_parameters = { "method.response.header.Access-Control-Allow-Origin" = true }

  depends_on = [
    aws_api_gateway_method.processing_put
  ]
}

resource "aws_api_gateway_integration_response" "processing_put" {
  for_each = local.api_status_response

  rest_api_id = local.apigw_id
  resource_id = aws_api_gateway_resource.processing.id
  http_method = "PUT"

  status_code       = each.value.code
  selection_pattern = each.value.pattern

  response_parameters = { "method.response.header.Access-Control-Allow-Origin" = "'${local.options_domains}'" }

  depends_on = [
    aws_api_gateway_method.processing_put,
    aws_api_gateway_integration.processing_put,
    aws_api_gateway_method_response.processing_put
  ]
}
