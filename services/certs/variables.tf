
locals {
  domain = "testigoelectoral.org"
  api_domain_environment = {
    "production" = "api.${local.domain}"
    "dev" = "api-dev.${local.domain}"
    "stage" = "api-stage.${local.domain}"
  }
  api_domain = local.api_domain_environment[local.environment]
}
