locals {
  org    = "testigoelectoral"
  domain = "testigoelectoral.org"
}

data "aws_route53_zone" "testigo" {
  name         = local.domain
  private_zone = false
}

data "tfe_outputs" "certs" {
  organization = local.org
  workspace    = "${var.environment}-001-certs"
}

data "tfe_outputs" "apigw" {
  organization = local.org
  workspace    = "${var.environment}-002-api-gateway"
}

locals {
  cognito_domain = data.tfe_outputs.certs.values.domain_cognito
  cognito_cert   = data.tfe_outputs.certs.values.arn_cognito
  apigw_id       = data.tfe_outputs.apigw.values.arn_api
}

output "pool_id" {
  value = aws_cognito_user_pool.testigo.id
}

output "pool_arn" {
  value = aws_cognito_user_pool.testigo.arn
}

output "pool_endpoint" {
  value = aws_cognito_user_pool.testigo.endpoint
}

output "client_id" {
  value = aws_cognito_user_pool_client.testigo.id
}

output "authorizer_id" {
  value = aws_api_gateway_authorizer.authorizer.id
}
