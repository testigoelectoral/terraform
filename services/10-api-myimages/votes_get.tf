
resource "aws_api_gateway_method" "votes_get" {
  rest_api_id = local.apigw_id
  resource_id = aws_api_gateway_resource.votes.id

  http_method   = "GET"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = local.cognito_autorizer

  request_parameters = {
    "method.request.path.imageid" = true,
  }

  depends_on = [
    aws_api_gateway_resource.votes
  ]
}

resource "aws_api_gateway_integration" "votes_get" {
  rest_api_id = local.apigw_id
  resource_id = aws_api_gateway_resource.votes.id
  http_method = aws_api_gateway_method.votes_get.http_method

  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = "arn:aws:apigateway:${local.region}:dynamodb:action/Scan"
  credentials             = aws_iam_role.myimages.arn

  request_templates = {
    "application/json" = <<EOF
      {
        "TableName": "${local.dynamodb_votes_name}",
        "FilterExpression": "(ImageID = :img) AND (CreatedBy = :sub)",
        "ExpressionAttributeValues": {
          ":img": {
              "S": "$method.request.path.imageid"
          },
          ":sub": {
              "S": "$context.authorizer.claims.sub"
          }
        }
      }
    EOF
  }

  depends_on = [
    aws_api_gateway_method.votes_get
  ]
}

resource "aws_api_gateway_method_response" "votes_get" {
  for_each = local.api_status_response

  rest_api_id = local.apigw_id
  resource_id = aws_api_gateway_resource.votes.id
  http_method = aws_api_gateway_method.votes_get.http_method

  status_code = each.value.code

  response_parameters = { "method.response.header.Access-Control-Allow-Origin" = true }

  depends_on = [
    aws_api_gateway_method.votes_get
  ]
}

resource "aws_api_gateway_integration_response" "votes_get" {
  for_each = {
    "BAD"   = local.api_status_response["BAD"]
    "ERROR" = local.api_status_response["ERROR"]
  }

  rest_api_id = local.apigw_id
  resource_id = aws_api_gateway_resource.votes.id
  http_method = aws_api_gateway_method.votes_get.http_method

  status_code       = aws_api_gateway_method_response.votes_get[each.key].status_code
  selection_pattern = each.value.pattern

  response_parameters = { "method.response.header.Access-Control-Allow-Origin" = "'${local.options_domains}'" }

  depends_on = [
    aws_api_gateway_method_response.get
  ]
}

resource "aws_api_gateway_integration_response" "votes_get-response" {

  rest_api_id = local.apigw_id
  resource_id = aws_api_gateway_resource.votes.id
  http_method = aws_api_gateway_method.votes_get.http_method

  status_code       = aws_api_gateway_method_response.votes_get["OK"].status_code
  selection_pattern = local.api_status_response["OK"].pattern

  response_templates = {
    "application/json" = <<EOF
      #set($inputRoot = $input.path('$'))
      [
        #foreach($elem in $inputRoot.Items) {
        "ImageVotesID": "$elem.ImageVotesID.S",
        "CreatedAt": "$elem.CreatedAt.S",
        "Votes": {
          #foreach($key in $elem.Votes.M.keySet())
          "$key": $elem.Votes.M.get($key).N#if($foreach.hasNext),#end
          #end
        }
        }#if($foreach.hasNext),#end
        #end
      ]

    EOF
  }

  response_parameters = { "method.response.header.Access-Control-Allow-Origin" = "'${local.options_domains}'" }

  depends_on = [
    aws_api_gateway_method_response.get
  ]
}
