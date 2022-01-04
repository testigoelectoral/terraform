
locals {
  org = "testigoelectoral"
}

data "tfe_outputs" "certs" {
  organization = local.org
  workspace    = "${var.environment}-001-certs"
}

data "tfe_outputs" "api" {
  organization = local.org
  workspace    = "${var.environment}-002-api-gateway"
}

locals {
  api_id      = data.tfe_outputs.api.values.arn_api
  domain_name = data.tfe_outputs.certs.values.domain_api
}
