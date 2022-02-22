
resource "aws_api_gateway_method" "votes_put" {
  rest_api_id = local.apigw_id
  resource_id = aws_api_gateway_resource.votes.id

  http_method   = "PUT"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = local.cognito_autorizer

  request_parameters = {
    "method.request.path.imageid" = true,
  }

  depends_on = [
    aws_api_gateway_resource.votes
  ]
}

resource "aws_api_gateway_integration" "votes_put" {
  rest_api_id = local.apigw_id
  resource_id = aws_api_gateway_resource.votes.id
  http_method = aws_api_gateway_method.votes_put.http_method

  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = "arn:aws:apigateway:${local.region}:dynamodb:action/PutItem"
  credentials             = aws_iam_role.myimages.arn

  request_templates = {
    "application/json" = <<EOF
      {
        #set($votes = $input.path('$.votes'))
        "TableName": "${local.dynamodb_votes_name}",
        "Item": {            
            "ImageID": {
                "S": "$method.request.path.imageid"
            },
            "Original": {
                "B": true
            },
            "CreatedAt": {
                "S": "$context.requestTime"
            },
            "Votes": {
                "M": {
                    #foreach($key in $votes.keySet())
                    "$key": {
                        "N": "$votes.get($key)"
                    }#if($foreach.hasNext),#end
                    #end
                }
            }
        }
      }
    EOF
  }

  depends_on = [
    aws_api_gateway_method.votes_put
  ]
}

resource "aws_api_gateway_method_response" "votes_put" {
  for_each = local.api_status_response

  rest_api_id = local.apigw_id
  resource_id = aws_api_gateway_resource.votes.id
  http_method = aws_api_gateway_method.votes_put.http_method

  status_code = each.value.code

  response_parameters = { "method.response.header.Access-Control-Allow-Origin" = true }

  depends_on = [
    aws_api_gateway_method.votes_put
  ]
}

resource "aws_api_gateway_integration_response" "votes_put" {
  for_each = local.api_status_response

  rest_api_id = local.apigw_id
  resource_id = aws_api_gateway_resource.votes.id
  http_method = aws_api_gateway_method.votes_put.http_method

  status_code       = aws_api_gateway_method_response.votes_put[each.key].status_code
  selection_pattern = each.value.pattern

  response_parameters = { "method.response.header.Access-Control-Allow-Origin" = "'${local.options_domains}'" }

  depends_on = [
    aws_api_gateway_method_response.get
  ]
}
