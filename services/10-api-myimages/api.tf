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

resource "aws_api_gateway_resource" "id_image" {
  rest_api_id = local.apigw_id
  parent_id   = aws_api_gateway_resource.myimages.id

  path_part = "{imageid}"
}

resource "aws_api_gateway_resource" "raw" {
  rest_api_id = local.apigw_id
  parent_id   = aws_api_gateway_resource.id_image.id

  path_part = "raw"
}
