
resource "aws_api_gateway_method" "get" {
  rest_api_id = local.apigw_id
  resource_id = aws_api_gateway_resource.myimages.id

  http_method   = "GET"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = local.cognito_autorizer

  depends_on = [
    aws_api_gateway_resource.myimages
  ]
}

resource "aws_api_gateway_integration" "get" {
  rest_api_id = local.apigw_id
  resource_id = aws_api_gateway_resource.myimages.id
  http_method = aws_api_gateway_method.get.http_method

  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = "arn:aws:apigateway:${local.region}:dynamodb:action/Query"
  credentials             = aws_iam_role.myimages.arn

  request_templates = {
    "application/json" = <<EOF
      {
        "TableName": "${local.dynamodb_images_name}",
        "KeyConditionExpression": "OwnerSub = :val",
        "ExpressionAttributeValues": {
          ":val": {
              "S": "$context.authorizer.claims.sub"
          }
        }
      }
    EOF
  }

  depends_on = [
    aws_api_gateway_method.get
  ]
}

resource "aws_api_gateway_method_response" "get" {
  for_each = local.api_status_response

  rest_api_id = local.apigw_id
  resource_id = aws_api_gateway_resource.myimages.id
  http_method = aws_api_gateway_method.get.http_method

  status_code = each.value.code

  depends_on = [
    aws_api_gateway_method.get
  ]
}

resource "aws_api_gateway_integration_response" "get" {
  for_each = local.api_status_response

  rest_api_id = local.apigw_id
  resource_id = aws_api_gateway_resource.myimages.id
  http_method = aws_api_gateway_method.get.http_method

  status_code       = aws_api_gateway_method_response.get[each.key].status_code
  selection_pattern = each.value.pattern

  depends_on = [
    aws_api_gateway_method_response.get
  ]
}
