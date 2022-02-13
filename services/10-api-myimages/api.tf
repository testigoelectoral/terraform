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

resource "aws_api_gateway_resource" "votes" {
  rest_api_id = local.apigw_id
  parent_id   = aws_api_gateway_resource.id_image.id

  path_part = "votes"
}

################################################################################################### 

module "options_root" {
  source          = "./options"
  resource_id     = aws_api_gateway_resource.myimages.id
  methods         = "GET,PUT"
  headers         = "Authorization,Content-Type,X-Amz-Meta-Accuracy,X-Amz-Meta-Latitude,X-Amz-Meta-Longitude,X-Amz-Meta-User-Hash,X-Amz-Meta-Qr-Code"
  options_domains = local.options_domains
  apigw_id        = local.apigw_id
}


module "options_id_image" {
  source          = "./options"
  resource_id     = aws_api_gateway_resource.id_image.id
  methods         = "GET"
  headers         = "Authorization"
  options_domains = local.options_domains
  apigw_id        = local.apigw_id
}

module "options_votes" {
  source          = "./options"
  resource_id     = aws_api_gateway_resource.votes.id
  methods         = "PUT,GET"
  headers         = "Authorization,Content-Type"
  options_domains = local.options_domains
  apigw_id        = local.apigw_id
}
