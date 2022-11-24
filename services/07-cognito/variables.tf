locals {
  org    = "testigoelectoral"
  domain = "testigoelectoral.org"
}

data "aws_route53_zone" "testigo" {
  name         = local.domain
  private_zone = false
}

locals {
  cognito_domain          = data.tfe_outputs.certs.values.domain_cognito
  app_domain              = data.tfe_outputs.certs.values.domain_app
  api_domain              = data.tfe_outputs.certs.values.domain_api
  cognito_cert            = data.tfe_outputs.certs.values.arn_cognito
  apigw_id                = data.tfe_outputs.apigw.values.arn_api
  # userhash_arn            = data.tfe_outputs.backend-cognito.values.hash_arn
}

output "authorizer_id" {
  value = aws_api_gateway_authorizer.authorizer.id
}

output "account_pool_id" {
  value = aws_cognito_user_pool.account.id
}

output "account_pool_arn" {
  value = aws_cognito_user_pool.account.arn
}

output "account_client_id" {
  value = aws_cognito_user_pool_client.account.id
}
