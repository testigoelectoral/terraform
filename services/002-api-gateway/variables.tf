
locals {
  org = "testigoelectoral"
  domain = "testigoelectoral.org"
}

data "tfe_outputs" "certs" {
  organization = local.org
  workspace = "${var.environment}-001-certs"
}

data "aws_route53_zone" "api" {
  name         = local.domain
  private_zone = false
}

locals {
  api_domain = data.tfe_outputs.certs.values.domain_api
  cert   = data.tfe_outputs.certs.values.arn_api
}

output "arn_api" {
  value = aws_api_gateway_rest_api.api.id
}

