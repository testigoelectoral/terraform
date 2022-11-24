
locals {
  org    = "testigoelectoral"
  domain = "testigoelectoral.org"
}

locals {
  app_domain_environment = {
    "prod"  = "https://app.${local.domain}"
    "dev"   = "https://app-dev.${local.domain}"
    "stage" = "https://app-stage.${local.domain}"
  }
  app_domain      = local.app_domain_environment[var.environment]
  options_domains = var.environment == "dev" ? "*" : local.app_domain
}

locals {
  apigw_id                  = data.tfe_outputs.apigw.values.arn_api
  apigw_root                = data.tfe_outputs.apigw.values.root_id
  cognito_autorizer         = data.tfe_outputs.cognito.values.authorizer_id
  account_pool_arn          = data.tfe_outputs.cognito.values.account_pool_arn
  account_cognito_client_id = data.tfe_outputs.cognito.values.account_client_id

  api_status_response = {
    "OK"    = { code = "200", pattern = "2\\d{2}" },
    "BAD"   = { code = "400", pattern = "4\\d{2}" },
    "ERROR" = { code = "500", pattern = "5\\d{2}" },
  }
}
