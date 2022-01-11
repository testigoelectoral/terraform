
locals {
  org    = "testigoelectoral"
  domain = "testigoelectoral.org"
}

data "aws_route53_zone" "api" {
  name         = local.domain
  private_zone = false
}

locals {
  api_domain = data.tfe_outputs.certs.values.domain_api
  cert       = data.tfe_outputs.certs.values.arn_api
}

output "arn_api" {
  value = aws_api_gateway_rest_api.api.id
}

output "root_id" {
  value = aws_api_gateway_rest_api.api.root_resource_id
}
