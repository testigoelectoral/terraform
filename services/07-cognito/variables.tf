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
  userhash_arn            = data.tfe_outputs.backend-cognito.values.hash_arn
  validations_arn         = data.tfe_outputs.backend-cognito.values.validations_arn
  cognito_callback_test   = ["http://localhost:3000", "http://localhost:3000/api/auth/callback/cognito"]
  cognito_callback_normal = ["https://${local.domain}", "https://${local.app_domain}", "https://${local.api_domain}"]
  cognito_callback        = var.environment == "dev" ? concat(local.cognito_callback_normal, local.cognito_callback_test) : local.cognito_callback_normal

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

output "account_pool_id" {
  value = aws_cognito_user_pool.account.id
}

output "account_pool_arn" {
  value = aws_cognito_user_pool.account.arn
}

output "account_pool_endpoint" {
  value = aws_cognito_user_pool.account.endpoint
}

output "account_client_id" {
  value = aws_cognito_user_pool_client.account.id
}
