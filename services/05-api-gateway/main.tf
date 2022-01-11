
resource "aws_api_gateway_rest_api" "api" {
  name = "api"

  tags = {
    environment = var.environment
  }

}

resource "aws_api_gateway_domain_name" "domain" {
  domain_name              = local.api_domain
  regional_certificate_arn = local.cert
  security_policy          = "TLS_1_2"

  endpoint_configuration {
    types = ["REGIONAL"]
  }

}

resource "aws_route53_record" "api" {
  name    = local.api_domain
  type    = "A"
  zone_id = data.aws_route53_zone.api.id

  alias {
    evaluate_target_health = true
    name                   = aws_api_gateway_domain_name.domain.regional_domain_name
    zone_id                = aws_api_gateway_domain_name.domain.regional_zone_id
  }
}
