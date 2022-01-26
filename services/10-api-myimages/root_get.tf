
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
  uri                     = "arn:aws:apigateway:${local.region}:dynamodb:action/Scan"
  credentials             = aws_iam_role.myimages.arn

  request_templates = {
    "application/json" = <<EOF
      {
        "TableName": "${local.dynamodb_images_name}",
        "FilterExpression": "OwnerSub = :val",
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
  for_each = {
    "BAD"   = local.api_status_response["BAD"]
    "ERROR" = local.api_status_response["ERROR"]
  }

  rest_api_id = local.apigw_id
  resource_id = aws_api_gateway_resource.myimages.id
  http_method = aws_api_gateway_method.get.http_method

  status_code       = aws_api_gateway_method_response.get[each.key].status_code
  selection_pattern = each.value.pattern



  depends_on = [
    aws_api_gateway_method_response.get
  ]
}

resource "aws_api_gateway_integration_response" "get-response" {

  rest_api_id = local.apigw_id
  resource_id = aws_api_gateway_resource.myimages.id
  http_method = aws_api_gateway_method.get.http_method

  status_code       = aws_api_gateway_method_response.get["OK"].status_code
  selection_pattern = local.api_status_response["OK"].pattern

  response_templates = {
    "application/json" = <<EOF
    #set($inputRoot = $input.path('$'))
    [
      #foreach($elem in $inputRoot.Items) {
      "OwnerReport": $elem.OwnerReport.BOOL,
      "ImageID": "$elem.ImageID.S",
      "CreatedAt": "$elem.CreatedAt.S"
      }#if($foreach.hasNext),#end
      #end
    ]
    EOF
  }

  depends_on = [
    aws_api_gateway_method_response.get
  ]
}
