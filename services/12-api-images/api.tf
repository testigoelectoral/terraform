resource "aws_api_gateway_resource" "images" {
  rest_api_id = local.apigw_id
  parent_id   = local.apigw_root
  path_part   = "images"
}

resource "aws_api_gateway_resource" "images_id" {
  rest_api_id = local.apigw_id
  parent_id   = aws_api_gateway_resource.images.id
  path_part   = "{imageid}"
  depends_on  = [aws_api_gateway_resource.images]
}

