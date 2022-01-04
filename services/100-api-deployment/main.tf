
resource "aws_api_gateway_deployment" "running" {
  rest_api_id = local.api_id

  triggers = {
    redeployment = timestamp()
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "running" {
  deployment_id = aws_api_gateway_deployment.running.id
  rest_api_id   = local.api_id
  stage_name    = var.environment
}

resource "aws_api_gateway_base_path_mapping" "mapping" {
  api_id      = local.api_id
  stage_name  = aws_api_gateway_stage.running.stage_name
  domain_name = local.domain_name
}