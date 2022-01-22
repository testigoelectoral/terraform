resource "aws_api_gateway_resource" "myimages" {
  rest_api_id = local.apigw_id
  parent_id   = local.apigw_root

  path_part = "myimages"
}

resource "aws_api_gateway_request_validator" "parameters" {
  name                        = "validate-parameters"
  rest_api_id                 = local.apigw_id
  validate_request_body       = false
  validate_request_parameters = true
}
