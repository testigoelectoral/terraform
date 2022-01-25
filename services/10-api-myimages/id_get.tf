
resource "aws_api_gateway_method" "id_get" {
  rest_api_id = local.apigw_id
  resource_id = aws_api_gateway_resource.id_image.id

  http_method   = "GET"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = local.cognito_autorizer

  request_parameters = {
    "method.request.path.imageid" = true,
  }

  depends_on = [
    aws_api_gateway_resource.id_image
  ]
}

resource "aws_api_gateway_integration" "id_get" {
  rest_api_id = local.apigw_id
  resource_id = aws_api_gateway_resource.id_image.id
  http_method = aws_api_gateway_method.id_get.http_method

  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = "arn:aws:apigateway:${local.region}:dynamodb:action/Query"
  credentials             = aws_iam_role.myimages.arn

  request_templates = {
    "application/json" = <<EOF
      {
        "TableName": "${local.dynamodb_images_name}",
        "KeyConditionExpression": "ImageId = :val",
        "ExpressionAttributeValues": {
          ":val": {
              "S": "$input.path('$.imageid')"
          }
        }
      }
    EOF
  }

  depends_on = [
    aws_api_gateway_method.id_get
  ]
}

resource "aws_api_gateway_method_response" "id_get" {
  for_each = local.api_status_response

  rest_api_id = local.apigw_id
  resource_id = aws_api_gateway_resource.id_image.id
  http_method = aws_api_gateway_method.id_get.http_method

  status_code = each.value.code

  depends_on = [
    aws_api_gateway_method.id_get
  ]
}

resource "aws_api_gateway_integration_response" "id_get" {
  for_each = local.api_status_response

  rest_api_id = local.apigw_id
  resource_id = aws_api_gateway_resource.id_image.id
  http_method = aws_api_gateway_method.id_get.http_method

  status_code       = aws_api_gateway_method_response.id_get[each.key].status_code
  selection_pattern = each.value.pattern

  depends_on = [
    aws_api_gateway_method_response.get
  ]
}
