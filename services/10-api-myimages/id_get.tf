
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
        "KeyConditionExpression": "ImageID = :val",
        "ExpressionAttributeValues": {
          ":val": {
              "S": "$method.request.path.imageid"
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
  for_each = {
    "BAD"   = local.api_status_response["BAD"]
    "ERROR" = local.api_status_response["ERROR"]
  }

  rest_api_id = local.apigw_id
  resource_id = aws_api_gateway_resource.id_image.id
  http_method = aws_api_gateway_method.id_get.http_method

  status_code       = aws_api_gateway_method_response.id_get[each.key].status_code
  selection_pattern = each.value.pattern

  depends_on = [
    aws_api_gateway_method_response.get
  ]
}

resource "aws_api_gateway_integration_response" "id_get-response" {

  rest_api_id = local.apigw_id
  resource_id = aws_api_gateway_resource.id_image.id
  http_method = aws_api_gateway_method.id_get.http_method

  status_code       = aws_api_gateway_method_response.id_get["OK"].status_code
  selection_pattern = local.api_status_response["OK"].pattern

  response_templates = {
    "application/json" = <<EOF
      #set($inputRoot = $input.path('$'))
      {
        "OwnerReport": $inputRoot.Items[0].OwnerReport.BOOL,
        "CreatedAt": "$inputRoot.Items[0].CreatedAt.S",
        "StateCode": $inputRoot.Items[0].PageMeta.M.LocationStateCode.N,
        "MunicipalityCode": $inputRoot.Items[0].PageMeta.M.LocationMunicipalityCode.N,
        "ZoneCode": $inputRoot.Items[0].PageMeta.M.LocationZoneCode.N,
        "PlaceCode": $inputRoot.Items[0].PageMeta.M.LocationPlace.N,
        "Table": $inputRoot.Items[0].PageMeta.M.LocationTable.N,
        "TypeCode": $inputRoot.Items[0].PageMeta.M.PageType.N,
        "PageNumber": $inputRoot.Items[0].PageMeta.M.PageNumber.N
      }
    EOF
  }

  depends_on = [
    aws_api_gateway_method_response.get
  ]
}
