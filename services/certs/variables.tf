
locals {
  api_domain_environment = {
    "production" = "api.testigoelectoral.org"
    "dev" = "api-dev.testigoelectoral.org"
    "stage" = "api-stage.testigoelectoral.org"
  }
  api_domain = loca.api_domain_environment[local.environment]
}
