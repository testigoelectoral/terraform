
locals {
  org = "testigoelectoral"
}

data "tfe_outputs" "api" {
  organization = local.org
  workspace    = "${var.environment}-002-api-gateway"
}

locals {
  api_id = data.tfe_outputs.api.values.arn_api
  # domain_name = data.tfe_outputs.api.domain_name
}
