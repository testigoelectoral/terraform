
locals {
  domain = "testigoelectoral.org"
  api_domain_environment = {
    "prod" = "api.${local.domain}"
    "dev" = "api-dev.${local.domain}"
    "stage" = "api-stage.${local.domain}"
  }
  api_domain = local.api_domain_environment[var.environment]
}

output "arn_api" {
  value = aws_acm_certificate.api.id
}

output "domain_api" {
  value = local.api_domain
}