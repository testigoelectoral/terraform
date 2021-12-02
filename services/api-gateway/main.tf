
resource "aws_api_gateway_rest_api" "api" {
  name = "api"

  tags = {
    environment = var.environment
  }

}
