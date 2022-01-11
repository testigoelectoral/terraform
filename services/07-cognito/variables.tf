locals {
  org    = "testigoelectoral"
  domain = "testigoelectoral.org"
}

data "aws_route53_zone" "testigo" {
  name         = local.domain
  private_zone = false
}

locals {
  cognito_domain = data.tfe_outputs.certs.values.domain_cognito
  app_domain     = data.tfe_outputs.certs.values.domain_api
  cognito_cert   = data.tfe_outputs.certs.values.arn_cognito
  apigw_id       = data.tfe_outputs.apigw.values.arn_api
  userhash_arn   = data.tfe_outputs.userhash.values.arn
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
