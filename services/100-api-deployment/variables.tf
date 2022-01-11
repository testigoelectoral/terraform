
locals {
  org = "testigoelectoral"
}

locals {
  api_id      = data.tfe_outputs.api.values.arn_api
  domain_name = data.tfe_outputs.certs.values.domain_api
}
